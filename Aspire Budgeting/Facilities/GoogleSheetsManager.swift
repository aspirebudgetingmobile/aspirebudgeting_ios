//
//  GoogleSheetsManager.swift
//  Aspire Budgeting
//

import Combine
import Foundation
import GoogleAPIClientForREST
import GTMSessionFetcher
import os.log

protocol RemoteFileReader {
  func read(file: File,
            user: User,
            location: String) -> AnyPublisher<AnyObject, Error>
}

protocol RemoteFileWriter {
  func write(file: File, user: User, location: String)
}

typealias RemoteFileReaderWriter = RemoteFileReader & RemoteFileWriter

protocol ContentReader {
  func getDashboard(for user: User,
                    from file: File,
                    using dataMap: [String: String],
                    completion: @escaping (Result<DashboardMetadata>) -> Void)
}

protocol ContentWriter {
  func addTransaction()
}

enum Result<T> {
  case success(T)
  case failure(Error)
}
typealias ContentProvider = ContentReader & ContentWriter

final class GoogleContentManager: ContentProvider {
  private let fileReader: RemoteFileReader
  private let fileWriter: RemoteFileWriter
  private var readSink: AnyCancellable!

  enum SupportedLegacyVersion: String {
    case twoEight = "2.8"
    case three = "3.0"
    case threeOne = "3.1.0"
    case threeTwo = "3.2.0"
  }

  init(fileReader: RemoteFileReader,
       fileWriter: RemoteFileWriter) {
    self.fileReader = fileReader
    self.fileWriter = fileWriter
  }

  func getDashboard(for user: User,
                    from file: File,
                    using dataMap: [String: String],
                    completion: @escaping (Result<DashboardMetadata>) -> Void) {
    if let location = dataMap["Dashboard"] {
      readSink = fileReader.read(file: file,
                                 user: user,
                                 location: location)
        .sink(receiveCompletion: { error in

        }, receiveValue: { valueRange in

        })
    } else {
      readSink = fileReader.read(file: file,
                                 user: user,
                                 location: "BackendData!2:2")
        .map { valueRange -> String in
          guard let version = (valueRange as? GTLRSheets_ValueRange)?
            .values?
            .last?
            .last as? String,
            let supportedVersion = SupportedLegacyVersion(rawValue: version) else {
              return ""
          }
          let range: String
          switch supportedVersion {
          case .twoEight, .three, .threeOne:
            range = "Dashboard!F4:O"
          case .threeTwo:
            range = "Dashboard!F6:O"
          }
          return range
        }
        .flatMap { location -> AnyPublisher<AnyObject, Error> in
          self.fileReader.read(file: file,
                               user: user,
                               location: location)
        }
        .sink(receiveCompletion: { status in
          switch status {
          case .failure(let error):
            completion(.failure(error))
          default:
            print("Dashboard data retrieved")
          }
        }, receiveValue: { valueRange in
          guard let rows = (valueRange as? GTLRSheets_ValueRange)?.values as? [[String]] else {
            completion(.failure(GoogleDriveManagerError.inconsistentSheet))
            return
          }
          let metadata = DashboardMetadata(rows: rows)
          completion(.success(metadata))
        })
    }
  }

  func addTransaction() {
    
  }
}

final class GoogleSheetsManager: ObservableObject, RemoteFileReaderWriter {
  func read(file: File,
            user: User,
            location: String) -> AnyPublisher<AnyObject, Error> {

    let future = Future<AnyObject, Error> { promise in
      self.fetchData(spreadsheet: file,
                     spreadsheetRange: location,
                     authorizer: user.authorizer as? GTMFetcherAuthorizationProtocol) { (valueRange, error) in
                      if let error = error {
                        promise(.failure(error))
                      } else {
                        promise(.success(valueRange!))
                      }
      }
    }
      //    .print()
      .eraseToAnyPublisher()

    return future
  }

  func write(file: File, user: User, location: String) {

  }

  enum SupportedAspireVersions: String {
    case twoEight = "2.8"
    case three = "3.0"
    case threeOne = "3.1.0"
    case threeTwo = "3.2.0"
  }

  private let sheetsService: GTLRService
  private let getSpreadsheetsQuery: GTLRSheetsQuery_SpreadsheetsValuesGet

  private var logoutObserver: NSObjectProtocol?

  private var ticket: GTLRServiceTicket?

  @Published private(set) var aspireVersion: SupportedAspireVersions?
  @Published private(set) var error: GoogleDriveManagerError?
  @Published private(set) var dashboardMetadata: DashboardMetadata?
  @Published private(set) var transactionCategories: [String]?
  @Published private(set) var transactionAccounts: [String]?
  @Published private(set) var accountBalancesMetadata: AccountBalancesMetadata?

  init(
    sheetsService: GTLRService = GTLRSheetsService(),
    getSpreadsheetsQuery: GTLRSheetsQuery_SpreadsheetsValuesGet
    = GTLRSheetsQuery_SpreadsheetsValuesGet.query(withSpreadsheetId: "", range: "")
  ) {
    self.sheetsService = sheetsService
    self.getSpreadsheetsQuery = getSpreadsheetsQuery
  }

  private func fetchData(
    spreadsheet: File,
    spreadsheetRange: String,
    authorizer: GTMFetcherAuthorizationProtocol?,
    completion: @escaping (GTLRSheets_ValueRange?, Error?) -> Void
  ) {
    guard let authorizer = authorizer else {
      os_log(
        "Nil authorizer while trying to fetch data",
        log: .sheetsManager,
        type: .error
      )
      completion(nil, GoogleDriveManagerError.nilAuthorizer)
      return
    }

    sheetsService.authorizer = authorizer
    getSpreadsheetsQuery.isQueryInvalid = false

    getSpreadsheetsQuery.spreadsheetId = spreadsheet.id
    getSpreadsheetsQuery.range = spreadsheetRange

    ticket = sheetsService.executeQuery(getSpreadsheetsQuery) { _, data, error in
      if let valueRange = data as? GTLRSheets_ValueRange {
        os_log(
          "Received GTLRSheets_ValueRange from Google Sheets",
          log: .sheetsManager,
          type: .default
        )
        completion(valueRange, error)
      }

      if let error = error as NSError? {
        if error.domain == kGTLRErrorObjectDomain {
          os_log(
            "Encountered kGTLRErrorObjectDomain: %{public}s",
            log: .sheetsManager,
            type: .error,
            error.localizedDescription
          )
          completion(nil, GoogleDriveManagerError.inconsistentSheet)
        } else {
          os_log(
            "No internet connection",
            log: .sheetsManager,
            type: .error
          )
          completion(nil, GoogleDriveManagerError.noInternet)
        }
      }
    }
  }

  private func createSheetsValueRangeFrom(
    amount: String,
    memo: String,
    date: Date,
    category: Int,
    account: Int,
    transactionType: Int,
    approvalType: Int
  ) -> GTLRSheets_ValueRange {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    dateFormatter.timeStyle = .none

    let sheetsValueRange = GTLRSheets_ValueRange()
    sheetsValueRange.majorDimension = kGTLRSheets_ValueRange_MajorDimension_Rows
    sheetsValueRange.range = "Transactions!B:H"

    var valuesToInsert = [String]()
    valuesToInsert.append(dateFormatter.string(from: date))

    if transactionType == 0 {
      valuesToInsert.append("")
      valuesToInsert.append(amount)
    } else {
      valuesToInsert.append(amount)
      valuesToInsert.append("")
    }

    valuesToInsert.append(transactionCategories![category])
    valuesToInsert.append(transactionAccounts![account])
    valuesToInsert.append("\(memo) - Added from Aspire iOS app")

    guard let version = aspireVersion else {
      fatalError("Aspire Version is nil")
    }

    switch version {
    case .twoEight:
      if approvalType == 0 {
        valuesToInsert.append("🆗")
      } else {
        valuesToInsert.append("⏺")
      }

    case .three, .threeOne, .threeTwo:
      if approvalType == 0 {
        valuesToInsert.append("✅")
      } else {
        valuesToInsert.append("🅿️")
      }
    }

    sheetsValueRange.values = [valuesToInsert]
    return sheetsValueRange
  }
}

// MARK: Reading from Google Sheets

extension GoogleSheetsManager {
  func getTransactionCategories(spreadsheet: File) {
    os_log(
      "Fetching transaction categories",
      log: .sheetsManager,
      type: .default
    )

    guard let version = aspireVersion else {
      os_log(
        "Aspire version is nil",
        log: .sheetsManager,
        type: .error
      )
      fatalError("Aspire Version is nil")
    }

    let range: String
    switch version {
    case .twoEight:
      range = "BackendData!B2:B"
    case .three, .threeOne:
      range = "BackendData!F2:F"
    case .threeTwo:
      range = "BackendData!G2:G"
    }

    //    fetchData(spreadsheet: spreadsheet, spreadsheetRange: range) { valueRange in
    //      guard let values = valueRange.values as? [[String]] else {
    //        fatalError("Values from Google sheet is nil")
    //      }
    //
    //      os_log(
    //        "Received transaction categories",
    //        log: .sheetsManager,
    //        type: .default
    //      )
    //      self.transactionCategories = values.map { $0.first! }
    //    }
  }

  func getTransactionAccounts(spreadsheet: File) {
    os_log(
      "Fetching transaction accounts",
      log: .sheetsManager,
      type: .default
    )

    guard let version = aspireVersion else {
      os_log(
        "Aspire version is nil",
        log: .sheetsManager,
        type: .error
      )
      fatalError("Aspire Version is nil")
    }

    let range: String
    switch version {
    case .twoEight:
      range = "BackendData!E2:E"
    case .three:
      range = "BackendData!H2:H"
    case .threeOne:
      range = "BackendData!J2:J"
    case .threeTwo:
      range = "BackendData!M2:M"
    }

    //    fetchData(spreadsheet: spreadsheet, spreadsheetRange: range) { valueRange in
    //      guard let values = valueRange.values as? [[String]] else {
    //        fatalError("Values from Google sheet is nil")
    //      }
    //
    //      os_log(
    //        "Received transaction accounts",
    //        log: .sheetsManager,
    //        type: .default
    //      )
    //
    //      self.transactionAccounts = values.map { $0.first! }
    //    }
  }

  func verifySheet(spreadsheet: File) {
    os_log(
      "Verifying selected Google Sheet",
      log: .sheetsManager,
      type: .default
    )

    //    fetchData(spreadsheet: spreadsheet, spreadsheetRange: "BackendData!2:2") { valueRange in
    //      if let version = valueRange.values?.first?.last as? String {
    //        self.aspireVersion = SupportedAspireVersions(rawValue: version)
    //        self.persistSheetID(spreadsheet: spreadsheet)
    //        self.fetchCategoriesAndGroups(spreadsheet: spreadsheet,
    //                                      spreadsheetVersion: self.aspireVersion!)
    //        self.getTransactionCategories(spreadsheet: spreadsheet)
    //        self.getTransactionAccounts(spreadsheet: spreadsheet)
    //        self.fetchAccountBalances(spreadsheet: spreadsheet)
    //      }
    //    }
  }

  func fetchCategoriesAndGroups(spreadsheet: File, spreadsheetVersion: SupportedAspireVersions) {
    os_log(
      "Fetching Categories and groups",
      log: .sheetsManager,
      type: .default
    )

    let range: String
    switch spreadsheetVersion {
    case .twoEight, .three, .threeOne:
      range = "Dashboard!F4:O"
    case .threeTwo:
      range = "Dashboard!F6:O"
    }
    //    fetchData(spreadsheet: spreadsheet, spreadsheetRange: range) { valueRange in
    //      if let values = valueRange.values as? [[String]] {
    //        self.dashboardMetadata = DashboardMetadata(rows: values)
    //      }
    //    }
  }

  func fetchAccountBalances(spreadsheet: File) {
    os_log(
      "Fetching Account Balances",
      log: .sheetsManager,
      type: .default
    )

    guard let version = aspireVersion else {
      os_log(
        "Aspire version is nil",
        log: .sheetsManager,
        type: .error
      )
      fatalError("Aspire Version is nil")
    }

    let range: String
    switch version {
    case .twoEight, .three, .threeOne:
      range = "Dashboard!B10:C"
    case .threeTwo:
      range = "Dashboard!B8:C"
    }

    //    fetchData(spreadsheet: spreadsheet, spreadsheetRange: range) { valueRange in
    //      if let values = valueRange.values as? [[String]] {
    //        self.accountBalancesMetadata = AccountBalancesMetadata(metadata: values)
    //      }
    //    }
  }
}

// MARK: Writing to Google Sheets

extension GoogleSheetsManager {
  func addTransaction(
    amount: String,
    memo: String,
    date: Date,
    category: Int,
    account: Int,
    transactionType: Int,
    approvalType: Int,
    completion: @escaping (Bool) -> Void
  ) {
    os_log(
      "Adding transaction",
      log: .sheetsManager,
      type: .default
    )

    let valuesToInsert = createSheetsValueRangeFrom(
      amount: amount,
      memo: memo,
      date: date,
      category: category,
      account: account,
      transactionType: transactionType,
      approvalType: approvalType
    )

    //    guard let authorizer = self.authorizer else {
    //      os_log(
    //        "Aspire version is nil",
    //        log: .sheetsManager,
    //        type: .error
    //      )
    //      error = GoogleDriveManagerError.nilAuthorizer
    //      return
    //    }

    //    sheetsService.authorizer = authorizer
    //
    //    let appendQuery = GTLRSheetsQuery_SpreadsheetsValuesAppend.query(
    //      withObject: valuesToInsert,
    //      spreadsheetId: defaultFile!.id,
    //      range: valuesToInsert.range!
    //    )
    //
    //    appendQuery.valueInputOption = kGTLRSheetsValueInputOptionUserEntered

    //    ticket = sheetsService.executeQuery(appendQuery) { _, _, error in
    //      if let error = error as NSError? {
    //        if error.domain == kGTLRErrorObjectDomain {
    //          os_log(
    //            "Encountered kGTLRErrorObjectDomain: %{public}s",
    //            log: .sheetsManager,
    //            type: .error,
    //            error.localizedDescription
    //          )
    //          self.error = GoogleDriveManagerError.inconsistentSheet
    //        } else {
    //          os_log(
    //            "No internet connection",
    //            log: .sheetsManager,
    //            type: .error
    //          )
    //          self.error = GoogleDriveManagerError.noInternet
    //        }
    //      }
    //      self.fetchAccountBalances(spreadsheet: self.defaultFile!)
    //      completion(error == nil)
    //    }
  }
}

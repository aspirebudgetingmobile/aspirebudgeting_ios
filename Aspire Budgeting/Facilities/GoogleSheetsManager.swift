//
//  GoogleSheetsManager.swift
//  Aspire Budgeting
//

import Combine
import Foundation
import GoogleAPIClientForREST
import GTMSessionFetcher

protocol RemoteFileReader {
  func read(file: File,
            user: User,
            location: String) -> AnyPublisher<AnyObject, Error>
}

protocol RemoteFileWriter {
  func write(file: File, user: User, location: String)
}

typealias RemoteFileReaderWriter = RemoteFileReader & RemoteFileWriter

enum Result<T> {
  case success(T)
  case failure(Error)
}

final class GoogleSheetsManager: ObservableObject, RemoteFileReaderWriter {
  func read(file: File,
            user: User,
            location: String) -> AnyPublisher<AnyObject, Error> {

    let future = Future<AnyObject, Error> { promise in
      let authorizer = user.authorizer as? GTMFetcherAuthorizationProtocol

      self.fetchData(spreadsheet: file,
                     spreadsheetRange: location,
                     authorizer: authorizer) { valueRange, error in
                      if let error = error {
                        promise(.failure(error))
                      } else {
                        promise(.success(valueRange!))
                      }
      }
    }
    .print()
    .eraseToAnyPublisher()

    return future
  }

  func write(file: File, user: User, location: String) {

  }

  //TODO: Remove enum
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
  @Published private(set) var dashboardMetadata: Dashboard?
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
      Logger.error(
        "Nil authorizer while trying to fetch data"
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
        Logger.info(
          "Read succesful from Google Sheets: ",
          context: spreadsheetRange
        )
        completion(valueRange, error)
      }

      if let error = error as NSError? {
        if error.domain == kGTLRErrorObjectDomain {
          Logger.error(
            "Encountered kGTLRErrorObjectDomain: ",
            context: error.localizedDescription
          )
          completion(nil, GoogleDriveManagerError.inconsistentSheet)
        } else {
          Logger.error(
            "No internet connection"
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
    Logger.info(
      "Fetching transaction categories"
    )

    guard let version = aspireVersion else {
      Logger.error(
        "Aspire version is nil"
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
    Logger.info(
      "Fetching transaction accounts"
    )

    guard let version = aspireVersion else {
      Logger.error(
        "Aspire version is nil"
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
    Logger.info(
      "Verifying selected Google Sheet"
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
    Logger.info(
      "Fetching Categories and groups"
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
    Logger.info(
      "Fetching Account Balances"
    )

    guard let version = aspireVersion else {
      Logger.error(
        "Aspire version is nil"
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
    Logger.info(
      "Adding transaction"
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

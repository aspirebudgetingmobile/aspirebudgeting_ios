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
            locations: [String]) -> AnyPublisher<Any, Error>
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
            locations: [String]) -> AnyPublisher<Any, Error> {

    let future = Future<Any, Error> { promise in
      let authorizer = user.authorizer as? GTMFetcherAuthorizationProtocol

      self.fetchData(spreadsheet: file,
                     spreadsheetRanges: locations,
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
  private let getSpreadsheetsQuery: GTLRSheetsQuery_SpreadsheetsValuesBatchGet

  private var logoutObserver: NSObjectProtocol?

  private var ticket: GTLRServiceTicket?

  @Published private(set) var aspireVersion: SupportedAspireVersions?
  @Published private(set) var error: GoogleDriveManagerError?
  @Published private(set) var transactionCategories: [String]?
  @Published private(set) var transactionAccounts: [String]?

  init(
    sheetsService: GTLRService = GTLRSheetsService(),
    getSpreadsheetsQuery: GTLRSheetsQuery_SpreadsheetsValuesBatchGet
    = GTLRSheetsQuery_SpreadsheetsValuesBatchGet.query(withSpreadsheetId: "")
  ) {
    self.sheetsService = sheetsService
    self.getSpreadsheetsQuery = getSpreadsheetsQuery
  }

  private func fetchData(
    spreadsheet: File,
    spreadsheetRanges: [String],
    authorizer: GTMFetcherAuthorizationProtocol?,
    completion: @escaping ([GTLRSheets_ValueRange]?, Error?) -> Void
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
    getSpreadsheetsQuery.ranges = spreadsheetRanges

    ticket = sheetsService.executeQuery(getSpreadsheetsQuery) { _, data, error in
      if let valueRanges = (data as? GTLRSheets_BatchGetValuesResponse)?.valueRanges {
        Logger.info(
          "Read succesful from Google Sheets: ",
          context: spreadsheetRanges
        )
        completion(valueRanges, error)
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

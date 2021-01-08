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
  func write(data: GTLRSheets_ValueRange,
             file: File,
             user: User,
             location: String) -> AnyPublisher<Any, Error>
}

typealias RemoteFileReaderWriter = RemoteFileReader & RemoteFileWriter

enum Result<T> {
  case success(T)
  case failure(Error)
}

final class GoogleSheetsManager: ObservableObject, RemoteFileReaderWriter {
  private let sheetsService: GTLRService
  private let getSpreadsheetsQuery: GTLRSheetsQuery_SpreadsheetsValuesBatchGet
  private var appendQuery: GTLRSheetsQuery_SpreadsheetsValuesAppend

  private var logoutObserver: NSObjectProtocol?

  private var ticket: GTLRServiceTicket?

  struct Dependencies {
    let sheetsService = GTLRSheetsService()
    let getSpreadsheetsQuery = GTLRSheetsQuery_SpreadsheetsValuesBatchGet
      .query(withSpreadsheetId: "")
    let appendQuery = GTLRSheetsQuery_SpreadsheetsValuesAppend
      .query(withObject: GTLRSheets_ValueRange(),
             spreadsheetId: "",
             range: "")
  }

  init(dependencies: Dependencies = Dependencies()) {
    self.sheetsService = dependencies.sheetsService
    self.getSpreadsheetsQuery = dependencies.getSpreadsheetsQuery
    self.appendQuery = dependencies.appendQuery
  }
}

// MARK: - Reading Google Sheet
extension GoogleSheetsManager {
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
}

// MARK: - Writing to Google Sheet
extension GoogleSheetsManager {
  private func append(data: GTLRSheets_ValueRange,
                      spreadsheet: File,
                      spreadsheetRange: String,
                      authorizer: GTMFetcherAuthorizationProtocol?,
                      completion: @escaping (Result<Bool>) -> Void
  ) {

    guard let authorizer = authorizer else {
      Logger.error(
        "Nil authorizer while trying to append data"
      )
      completion(.failure(GoogleDriveManagerError.nilAuthorizer))
      return
    }

    sheetsService.authorizer = authorizer

    appendQuery = GTLRSheetsQuery_SpreadsheetsValuesAppend
      .query(withObject: data,
             spreadsheetId: spreadsheet.id,
             range: spreadsheetRange)

    appendQuery.valueInputOption = kGTLRSheetsValueInputOptionUserEntered

    ticket = sheetsService.executeQuery(appendQuery) { _, _, error in
      if let error = error as NSError? {
        if error.domain == kGTLRErrorObjectDomain {
          Logger.error("Encountered kGTLRErrorObjectDomain: ",
                       context: error.localizedDescription)
        } else {
          Logger.error("No internet connection")
        }
        completion(.failure(error))
      } else {
        Logger.info("Data appended at: ",
                    context: spreadsheetRange)
        completion(.success(true))
      }
    }
  }

  func write(data: GTLRSheets_ValueRange,
             file: File,
             user: User,
             location: String) -> AnyPublisher<Any, Error> {

    let future = Future<Any, Error> { promise in
      let authorizer = user.authorizer as? GTMFetcherAuthorizationProtocol

      self.append(data: data,
                  spreadsheet: file,
                  spreadsheetRange: location,
                  authorizer: authorizer) { result in
        switch result {
        case.failure(let error):
          promise(.failure(error))
        case .success:
          promise(.success(true))
        }
      }

    }
    .print()
    .eraseToAnyPublisher()

    return future
  }
}

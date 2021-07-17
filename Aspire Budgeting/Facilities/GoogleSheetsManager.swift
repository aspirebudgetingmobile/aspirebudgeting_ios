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

protocol GSMDependencyCreator {
  var sheetsService: GTLRSheetsService { get }
  var readQuery: GTLRSheetsQuery_SpreadsheetsValuesBatchGet { get }

  func appendQuery(with object: GTLRSheets_ValueRange,
                   spreadsheetId: String,
                   range: String) -> GTLRSheetsQuery_SpreadsheetsValuesAppend
}

struct GSMDependencies: GSMDependencyCreator {
  var sheetsService = GTLRSheetsService()
  var readQuery = GTLRSheetsQuery_SpreadsheetsValuesBatchGet
    .query(withSpreadsheetId: "")

  func appendQuery(with object: GTLRSheets_ValueRange,
                   spreadsheetId: String,
                   range: String) -> GTLRSheetsQuery_SpreadsheetsValuesAppend {
    GTLRSheetsQuery_SpreadsheetsValuesAppend
      .query(withObject: object,
             spreadsheetId: spreadsheetId,
             range: range)
  }
}

final class GoogleSheetsManager: RemoteFileReaderWriter {
  private let dependencies: GSMDependencyCreator

  private var sheetsService: GTLRService {
    dependencies.sheetsService
  }

  private var readQuery: GTLRSheetsQuery_SpreadsheetsValuesBatchGet {
    dependencies.readQuery
  }

  private var ticket: GTLRServiceTicket?

  init(dependencies: GSMDependencyCreator = GSMDependencies()) {
    self.dependencies = dependencies
  }
}

// MARK: - Reading Google Sheet
extension GoogleSheetsManager {
  private func fetchData(
    spreadsheet: File,
    spreadsheetRanges: [String],
    authorizer: GTMFetcherAuthorizationProtocol,
    completion: @escaping ([GTLRSheets_ValueRange]?, Error?) -> Void
  ) {
    sheetsService.authorizer = authorizer
    readQuery.isQueryInvalid = false

    readQuery.spreadsheetId = spreadsheet.id
    readQuery.ranges = spreadsheetRanges

    ticket = sheetsService.executeQuery(readQuery) { _, data, error in
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
    Future<Any, Error> { promise in
      self.fetchData(spreadsheet: file,
                     spreadsheetRanges: locations,
                     authorizer: user.authorizer) { valueRange, error in
        if let error = error {
          promise(.failure(error))
        } else {
          promise(.success(valueRange!))
        }
      }
    }
    .eraseToAnyPublisher()
  }
}

// MARK: - Writing to Google Sheet
extension GoogleSheetsManager {
  private func append(data: GTLRSheets_ValueRange,
                      spreadsheet: File,
                      spreadsheetRange: String,
                      authorizer: GTMFetcherAuthorizationProtocol,
                      completion: @escaping (Result<Bool>) -> Void
  ) {
    sheetsService.authorizer = authorizer

    let appendQuery = dependencies
      .appendQuery(with: data,
                   spreadsheetId: spreadsheet.id,
                   range: spreadsheetRange)

    appendQuery.valueInputOption = kGTLRSheetsValueInputOptionUserEntered

    ticket = sheetsService.executeQuery(appendQuery) { _, response, error in
      if let error = error as NSError? {
        if error.domain == kGTLRErrorObjectDomain {
          Logger.error("Encountered kGTLRErrorObjectDomain: ",
                       context: error.localizedDescription)
        } else {
          Logger.error("No internet connection")
        }
        completion(.failure(error))
      } else {
        if let updatedRange = (response as? GTLRSheets_AppendValuesResponse)?
            .updates?
            .updatedRange {
          Logger.info("Data appended at: ",
                      context: updatedRange)
        }
        completion(.success(true))
      }
    }
  }

  func write(data: GTLRSheets_ValueRange,
             file: File,
             user: User,
             location: String) -> AnyPublisher<Any, Error> {

    let future = Future<Any, Error> { promise in
      self.append(data: data,
                  spreadsheet: file,
                  spreadsheetRange: location,
                  authorizer: user.authorizer) { result in
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

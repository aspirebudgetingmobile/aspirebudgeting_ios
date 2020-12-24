//
// GoogleContentManager.swift
// Aspire Budgeting
//

import Combine
import Foundation
import GoogleAPIClientForREST

protocol ContentReader {
  func getDashboard(for user: User,
                    from file: File,
                    using dataMap: [String: String],
                    completion: @escaping (Result<Dashboard>) -> Void)

  func getAccountBalances(for user: User,
                          from file: File,
                          using dataMap: [String: String],
                          completion: @escaping (Result<AccountBalances>) -> Void)
}

protocol ContentWriter {
  func addTransaction()
}

typealias ContentProvider = ContentReader & ContentWriter

final class GoogleContentManager {
  private let fileReader: RemoteFileReader
  private let fileWriter: RemoteFileWriter
  private var readSink: AnyCancellable!

  private let kDashboard = "Dashboard"
  private let kAccountBalances = "Account Balances"
  private let kVersionLocation = "BackendData!2:2"

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
}

extension GoogleContentManager: ContentReader {
  func getAccountBalances(for user: User,
                          from file: File,
                          using dataMap: [String: String],
                          completion: @escaping (Result<AccountBalances>) -> Void) {
    if let location = dataMap[kAccountBalances] {
      readSink = fileReader
        .read(file: file, user: user, location: location)
        .sink(receiveCompletion: { _ in //TODO: To be implemented for 3.3+
        }, receiveValue: { _ in //TODO: To be implemented for 3.3+
        })
    } else {
      readSink = fileReader
        .read(file: file, user: user, location: kVersionLocation)
        .map { self.getAccountBalancesRangeForVersion(in: $0) }
        .flatMap { self.fileReader.read(file: file, user: user, location: $0) }
        .sink(receiveCompletion: { status in
          switch status {
          case.failure(let error):
            completion(.failure(error))
          default:
            Logger.info("Account Balances retrieved")
          }
        }, receiveValue: { valueRange in
          guard let rows =
                  (valueRange as? GTLRSheets_ValueRange)?.values as? [[String]] else {
            completion(.failure(GoogleDriveManagerError.inconsistentSheet))
            return
          }
          let accountBalancesMetadata = AccountBalancesMetadata(metadata: rows)
          completion(.success(accountBalancesMetadata.accountBalances))
        })
    }
  }

  func getDashboard(for user: User,
                    from file: File,
                    using dataMap: [String: String],
                    completion: @escaping (Result<Dashboard>) -> Void) {
    if let location = dataMap[kDashboard] {
      readSink = fileReader
        .read(file: file, user: user, location: location)
        .sink(receiveCompletion: { _ in //TODO: To be implemented for 3.3+
        }, receiveValue: { _ in //TODO: To be implemented for 3.3+
        })
    } else {
      readSink = fileReader
        .read(file: file, user: user, location: kVersionLocation)
        .map { self.getDashboardRangeForVersion(in: $0) }
        .flatMap { self.fileReader.read(file: file, user: user, location: $0) }
        .sink(receiveCompletion: { status in
          switch status {
          case .failure(let error):
            completion(.failure(error))
          default:
            Logger.info("Dashboard data retrieved")
          }
        }, receiveValue: { valueRange in
        guard let rows =
          (valueRange as? GTLRSheets_ValueRange)?.values as? [[String]] else {
          completion(.failure(GoogleDriveManagerError.inconsistentSheet))
          return
        }
        let metadata = Dashboard(rows: rows)
        completion(.success(metadata))
      })
    }
  }
}

extension GoogleContentManager: ContentWriter {
  func addTransaction() {

  }
}

extension GoogleContentManager {
  private func getVersionFrom(_ valueRange: AnyObject) -> SupportedLegacyVersion? {
    guard let version = (valueRange as? GTLRSheets_ValueRange)?
            .values?
            .last?
            .last as? String,
          let supportedVersion = SupportedLegacyVersion(rawValue: version) else {
      return nil
    }
    return supportedVersion
  }

  private func getAccountBalancesRangeForVersion(in valueRange: AnyObject) -> String {
    guard let supportedVersion = getVersionFrom(valueRange) else {
      return ""
    }

    let range: String
    switch supportedVersion {
    case .twoEight, .three, .threeOne:
      range = "Dashboard!B10:C"
    case .threeTwo:
      range = "Dashboard!B8:C"
    }
    return range
  }

  private func getDashboardRangeForVersion(in valueRange: AnyObject) -> String {
    guard let supportedVersion = getVersionFrom(valueRange) else {
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
}

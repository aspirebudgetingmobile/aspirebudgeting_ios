//
// GoogleContentManager.swift
// Aspire Budgeting
//

import Combine
import Foundation
import GoogleAPIClientForREST

protocol ContentReader {
  func getData<T: ConstructableFromRows>(for user: User,
                                         from file: File,
                                         using dataMap: [String: String],
                                         completion: @escaping (Result<T>) -> Void)
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

  private var supportedLegacyVersion: SupportedLegacyVersion?

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
  func getData<T: ConstructableFromRows>(for user: User,
                                         from file: File,
                                         using dataMap: [String: String],
                                         completion: @escaping (Result<T>) -> Void) {

    if let location = getRange(of: T.self, from: dataMap) {
      readSink = fileReader
        .read(file: file, user: user, locations: [location])
        .sink(receiveCompletion: { _ in //TODO: To be implemented for 3.3+
        }, receiveValue: { _ in //TODO: To be implemented for 3.3+
        })
    } else {
      readSink = getVersion(for: file, user: user)
        .compactMap { self.getRange(of: T.self, for: $0) }
        .flatMap { self.fileReader.read(file: file, user: user, locations: [$0]) }
        .sink(receiveCompletion: { status in
          switch status {
          case.failure(let error):
            completion(.failure(error))
          default:
            Logger.info("\(T.self) retrieved")
          }
        }, receiveValue: { valueRanges in
          guard let rows =
                  (valueRanges as? [GTLRSheets_ValueRange])?
                  .first?
                  .values as? [[String]] else {
            completion(.failure(GoogleDriveManagerError.inconsistentSheet))
            return
          }
          let data = T(rows: rows)
          completion(.success(data))
        })
    }
  }
}

extension GoogleContentManager: ContentWriter {
  func addTransaction() {

  }
}

extension GoogleContentManager {
  private func getVersion(for file: File,
                          user: User) -> AnyPublisher<SupportedLegacyVersion, Error> {
    if let legacyVersion = supportedLegacyVersion {
      return Just(legacyVersion)
        .setFailureType(to: Error.self)
        .eraseToAnyPublisher()
    }

    return self.fileReader
      .read(file: file, user: user, locations: [kVersionLocation])
      .tryMap { valueRanges -> String in
        guard let version = (valueRanges as? [GTLRSheets_ValueRange])?
                .first?
                .values?
                .last?
                .last as? String else {
          Logger.error("Unable to extract version from GTLRSheets_ValueRange")
          throw GoogleDriveManagerError.inconsistentSheet
        }
        return version
      }
      .tryMap {
        guard let supportedVersion = SupportedLegacyVersion(rawValue: $0) else {
          Logger.error("Unsupported version: ", context: $0)
          throw GoogleSheetsValidationError.invalidSheet
        }
        Logger.info("Using Aspire Version: ", context: $0)
        self.supportedLegacyVersion = supportedVersion
        return supportedVersion
      }
      .eraseToAnyPublisher()
  }

  private func getRange<T>(of type: T.Type, for version: SupportedLegacyVersion) -> String? {
    switch T.self {
    case is AccountBalances.Type:
      return self.getAccountBalancesRange(for: version)

    case is Dashboard.Type:
      return self.getDashboardRange(for: version)

    default:
      Logger.info("Data requested for unknown type \(T.self).")
      return nil
    }
  }

  private func getRange<T>(of type: T.Type, from dataMap: [String: String]) -> String? {
    var dataLocationKey = ""
    switch T.self {
    case is AccountBalances.Type:
      dataLocationKey = kAccountBalances

    case is Dashboard.Type:
      dataLocationKey = kDashboard

    default:
      Logger.info("Data requested for unknown type \(T.self).")
      return nil
    }
    return dataMap[dataLocationKey]
  }

  private func getAccountBalancesRange(for supportedVersion: SupportedLegacyVersion)
  -> String {
    let range: String
    switch supportedVersion {
    case .twoEight, .three, .threeOne:
      range = "Dashboard!B10:C"
    case .threeTwo:
      range = "Dashboard!B8:C"
    }
    return range
  }

  private func getDashboardRange(for supportedVersion: SupportedLegacyVersion) -> String {
    let range: String
    switch supportedVersion {
    case .twoEight, .three, .threeOne:
      range = "Dashboard!F4:O"
    case .threeTwo:
      range = "Dashboard!F6:O"
    }
    return range
  }

  private func getTrxCategoriesRange(for supportedVersion: SupportedLegacyVersion) -> String {
    let range: String
    switch supportedVersion {
    case .twoEight:
      range = "BackendData!B2:B"
    case .three, .threeOne:
      range = "BackendData!F2:F"
    case .threeTwo:
      range = "BackendData!G2:G"
    }
    return range
  }

  private func getTrxAccountsRange(for supported: SupportedLegacyVersion) -> String {
    let range: String
    switch supported {
    case .twoEight:
      range = "BackendData!E2:E"
    case .three:
      range = "BackendData!H2:H"
    case .threeOne:
      range = "BackendData!J2:J"
    case .threeTwo:
      range = "BackendData!M2:M"
    }
    return range
  }
}

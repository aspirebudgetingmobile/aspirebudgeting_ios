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

    var dataLocationKey = ""
    switch T.self {
    case is AccountBalances.Type:
      dataLocationKey = kAccountBalances

    case is Dashboard.Type:
      dataLocationKey = kDashboard

    default:
      Logger.info("Data requested for unknown type.")
    }

    if let location = dataMap[dataLocationKey] {
      readSink = fileReader
        .read(file: file, user: user, location: location)
        .sink(receiveCompletion: { _ in //TODO: To be implemented for 3.3+
        }, receiveValue: { _ in //TODO: To be implemented for 3.3+
        })
    } else {
      readSink = fileReader
        .read(file: file, user: user, location: kVersionLocation) //Get the version
        .map {
          switch T.self {
          case is AccountBalances.Type:
            return self.getAccountBalancesRangeForVersion(in: $0)

          case is Dashboard.Type:
            return self.getDashboardRangeForVersion(in: $0)

          default:
            Logger.info("Data requested for unknown type.")
            return ""
          }
        }
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

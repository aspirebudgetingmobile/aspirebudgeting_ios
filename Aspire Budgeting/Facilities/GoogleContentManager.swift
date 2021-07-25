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
                                         using dataMap: [String: String]
                                         ) -> AnyPublisher<T, Error>

  func getBatchData<T: ConstructableFromBatchRequest>(for user: User,
                                                      from file: File,
                                                      using dataMap: [String: String],
                                                      completion: @escaping (Result<T>) -> Void)
}

protocol ContentWriter {
  func write<T>(data: T,
                for user: User,
                to file: File,
                using dataMap: [String: String],
                completion: @escaping (Result<Any>) -> Void)
}

typealias ContentProvider = ContentReader & ContentWriter

enum SupportedLegacyVersion: String {
  case twoEight = "2.8"
  case three = "3.0"
  case threeOne = "3.1.0"
  case threeTwo = "3.2.0"
  case threeThree = "3.3.0"
}

final class GoogleContentManager {
  private let fileReader: RemoteFileReader
  private let fileWriter: RemoteFileWriter
  private var readSink: AnyCancellable!

  private let kDashboard = "Dashboard"
  private let kAccountBalances = "Account Balances"
  private let kVersionLocation = "BackendData!2:2"
  private let kTrxCategories = "trx_CategoriesList"
  private let kTrxAccounts = "trx_AccountsList"

  private var supportedLegacyVersion: SupportedLegacyVersion?

  init(fileReader: RemoteFileReader,
       fileWriter: RemoteFileWriter) {
    self.fileReader = fileReader
    self.fileWriter = fileWriter
  }
}

// MARK: - ContentReader Implementation
extension GoogleContentManager: ContentReader {
  func getBatchData<T: ConstructableFromBatchRequest>(for user: User,
                                                      from file: File,
                                                      using dataMap: [String: String],
                                                      completion: @escaping (Result<T>) -> Void) {

    if let locations = getRanges(of: T.self, from: dataMap) {
      readSink = fileReader
        .read(file: file, user: user, locations: locations)
        .sink(receiveCompletion: { _ in // TODO: To be implemented for >3.3
        }, receiveValue: { _ in // TODO: To be implemented for >3.3
        })
    } else {
      readSink = getVersion(for: file, user: user)
        .compactMap { self.getRanges(of: T.self, for: $0) }
        .flatMap { self.fileReader.read(file: file, user: user, locations: $0) }
        .sink(receiveCompletion: { status in
          switch status {
          case .failure(let error):
            completion(.failure(error))
          default:
            Logger.info("\(T.self) retrieved")
          }
        }, receiveValue: { valueRanges in
          guard let ranges = (valueRanges as? [GTLRSheets_ValueRange]) else {
            Logger.error("Conversion to [GTLRSheets_ValueRange] failed.")
            completion(.failure(GoogleDriveManagerError.inconsistentSheet))
            return
          }
          var metadata = [[String]]()
          ranges.forEach { valueRange in
            guard let values = (valueRange.values as? [[String]]) else {
              Logger.error("Value range has no values.",
                           context: valueRange.range!)
              completion(.failure(GoogleDriveManagerError.inconsistentSheet))
              return
            }

            var list = [String]()
            values.forEach { value in
              guard let content = value.first else {
                Logger.error("No content found in GTLRSheets_ValueRange for ",
                             context: valueRange.range)
                completion(.failure(GoogleDriveManagerError.inconsistentSheet))
                return
              }
              list.append(content)
            }
            metadata.append(list)
          }
          let data = T(rowsList: metadata)
          completion(.success(data))
        })
    }
  }

  func getData<T: ConstructableFromRows>(
    for user: User,
    from file: File,
    using dataMap: [String: String]
  ) -> AnyPublisher<T, Error> {
    getRange(of: T.self, from: dataMap)
      .catch { _ in
        self.getVersion(for: file, user: user)
          .flatMap { (supportedVersion: SupportedLegacyVersion) -> AnyPublisher<String, Error> in
            self.getRange(of: T.self, for: supportedVersion)
          }
      }
      .flatMap {
        self.fileReader.read(file: file, user: user, locations: [$0])
      }
      .tryMap {
        guard
          let rows =
            ($0 as? [GTLRSheets_ValueRange])?
            .first?
            .values as? [[String]] else {
          throw GoogleDriveManagerError.inconsistentSheet
        }
        return T(rows: rows)
      }
      .eraseToAnyPublisher()
    }
}

// MARK: - ContentWriter Implementation
extension GoogleContentManager: ContentWriter {
  func write<T>(data: T,
                for user: User,
                to file: File,
                using dataMap: [String: String],
                completion: @escaping (Result<Any>) -> Void) {
//    if let location = getRange(of: T.self, from: dataMap) {
//      readSink = fileReader
//        .read(file: file, user: user, locations: [location])
//        .sink(receiveCompletion: { _ in //TODO: To be implemented for >3.3
//        }, receiveValue: { _ in //TODO: To be implemented for >3.3
//        })
//    } else {
//      readSink = getVersion(for: file, user: user)
//        .compactMap { self.getRange(of: T.self, for: $0) }
//        .flatMap { location -> AnyPublisher<Any, Error> in
//          let valueRange = self.createValueRange(from: data)
//          valueRange?.range = location
//          return self.fileWriter.write(data: valueRange!,
//                                       file: file,
//                                       user: user,
//                                       location: location)
//        }
//        .sink(receiveCompletion: { status in
//          switch status {
//          case .failure(let error):
//            completion(.failure(error))
//          default:
//            Logger.info("\(T.self) written")
//          }
//        }, receiveValue: { result in
//          completion(.success(result))
//        })
//    }
  }
}

// MARK: - Internal Helpers
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

  private func getRanges<T>(of type: T.Type, for version: SupportedLegacyVersion) -> [String]? {
    switch T.self {
    case is AddTransactionMetadata.Type:
      return [getTrxCategoriesRange(for: version),
              getTrxAccountsRange(for: version),
      ]
    default:
      Logger.info("Data requested for unknown type \(T.self)")
      return nil
    }
  }

  private func getRanges<T>(of type: T.Type, from dataMap: [String: String]) -> [String]? {
    switch T.self {
    case is AddTransactionMetadata.Type:
      guard let trxCategories = dataMap[kTrxCategories],
            let trxAccounts = dataMap[kTrxAccounts] else {
        Logger.error("No named range found for: ",
                     context: "\(kTrxCategories) or \(kTrxCategories)")
        return nil
      }
      return [trxCategories, trxAccounts]
    default:
      Logger.info("Data requested for unknown type \(T.self)")
      return nil
    }
  }

  private func getRange<T>(
    of type: T.Type,
    for version: SupportedLegacyVersion
  ) -> AnyPublisher<String, Error> {
    let range: String
    switch T.self {
    case is AccountBalances.Type:
      range = self.getAccountBalancesRange(for: version)

    case is Dashboard.Type:
      range = self.getDashboardRange(for: version)

    case is Transaction.Type:
      range = "Transactions!B:H"

    case is Transactions.Type:
      range = "Transactions!B9:H"

    default:
      Logger.info("Data requested for unknown type \(T.self).")
      // TODO: Change to appropriate error
      return Fail(error: GoogleSheetsValidationError.invalidSheet).eraseToAnyPublisher()
    }
    return Just(range).setFailureType(to: Error.self).eraseToAnyPublisher()
  }

  private func getRange<T>(
    of type: T.Type,
    from dataMap: [String: String]
  ) -> AnyPublisher<String, Error> {
    var dataLocationKey = ""
    switch T.self {
    case is AccountBalances.Type:
      dataLocationKey = kAccountBalances

    case is Dashboard.Type:
      dataLocationKey = kDashboard

    default:
      Logger.info("Data requested for unknown type \(T.self).")
      // TODO: appropriate error
      return Fail(error: GoogleSheetsValidationError.invalidSheet).eraseToAnyPublisher()
    }

    guard let range = dataMap[dataLocationKey] else {
      // TODO: appropriate error
      return Fail(error: GoogleSheetsValidationError.invalidSheet).eraseToAnyPublisher()
    }

    return Just(range).setFailureType(to: Error.self).eraseToAnyPublisher()
  }

  private func getAccountBalancesRange(for supportedVersion: SupportedLegacyVersion)
  -> String {
    let range: String
    switch supportedVersion {
    case .twoEight, .three, .threeOne:
      range = "Dashboard!B10:C"
    case .threeTwo, .threeThree:
      range = "Dashboard!B8:C"
    }
    return range
  }

  private func getDashboardRange(for supportedVersion: SupportedLegacyVersion) -> String {
    let range: String
    switch supportedVersion {
    case .twoEight, .three, .threeOne:
      range = "Dashboard!F4:O"
    case .threeTwo, .threeThree:
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
    case .threeTwo, .threeThree:
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
    case .threeTwo, .threeThree:
      range = "BackendData!M2:M"
    }
    return range
  }

  private func createValueRange<T>(from data: T) -> GTLRSheets_ValueRange? {
    guard let supportedVersion = supportedLegacyVersion else {
      Logger.error("Supported sheet version is nil")
      return nil
    }

    switch T.self {
    case is Transaction.Type:
      return ValueRangeCreator.valueRange(from: data as! Transaction,
                                          for: supportedVersion)
    default:
      Logger.info("ValueRange requested for unknown type \(T.self)")
      return nil
    }
  }
}

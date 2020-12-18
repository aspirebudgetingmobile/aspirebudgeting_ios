//
//  GoogleSDKCredentials.swift
//  Aspire Budgeting
//

import Foundation

enum CredentialsError: Error {
  case missingCredentialsPLIST
  case couldNotCreate
}

struct GoogleSDKCredentials: Codable {
  // swiftlint:disable identifier_name
  let CLIENT_ID: String
  let REVERSED_CLIENT_ID: String
  // swiftlint:enable identifier_name

  static func getCredentials(
    from fileName: String = "credentials",
    type: String = "plist",
    bundle: Bundle = Bundle.main,
    decoder: PropertyListDecoder = PropertyListDecoder()
  ) throws -> GoogleSDKCredentials {
    var credentialsData: Data
    var credentials: GoogleSDKCredentials

    guard let credentialsURL = bundle.url(forResource: fileName,
                                          withExtension: type)
    else {
      Logger.error("credentials.plist file not found")
      throw CredentialsError.missingCredentialsPLIST
    }

    do {
      credentialsData = try Data(contentsOf: credentialsURL)
      credentials = try decoder.decode(GoogleSDKCredentials.self, from: credentialsData)

    } catch {
      Logger.error(
        "Exception thrown while trying to create GoogleSDKCredentials",
        context: error.localizedDescription
      )
      throw CredentialsError.couldNotCreate
    }

    return credentials
  }
}

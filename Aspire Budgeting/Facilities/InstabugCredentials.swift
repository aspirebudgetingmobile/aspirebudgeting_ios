//
//  InstabugCredentials.swift
//  Aspire Budgeting
//

import Foundation

@available(*, deprecated, message: "To be removed as no value is added.")
struct InstabugCredentials: Codable {
  let beta: String
  let live: String

  static func getCredentials(
    from fileName: String = "instabug",
    type: String = "plist",
    bundle: Bundle = Bundle.main,
    decoder: PropertyListDecoder = PropertyListDecoder(
    )
  ) throws -> InstabugCredentials {
    var credentialsData: Data
    var credentials: InstabugCredentials

    guard let credentialsURL = bundle.url(forResource: fileName, withExtension: type) else {
      Logger.error(
        "instabug.plist file not found."
      )
      throw CredentialsError.missingCredentialsPLIST
    }

    do {
      credentialsData = try Data(contentsOf: credentialsURL)
      credentials = try decoder.decode(InstabugCredentials.self, from: credentialsData)
    } catch {
      Logger.error(
        "Exception thrown while trying to create InstabugCredentials: ",
        context: error.localizedDescription
      )
      throw CredentialsError.couldNotCreate
    }

    return credentials
  }
}

//
//  InstabugCredentials.swift
//  Aspire Budgeting
//
//  Created by TeraMo Labs on 3/5/20.
//  Copyright © 2020 TeraMo Labs. All rights reserved.
//

import Foundation
import os.log

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
      os_log("instabug.plist file not found.",
             log: OSLog.instabugCredentials,
             type: .error)
      throw CredentialsError.missingCredentialsPLIST
    }

    do {
      credentialsData = try Data(contentsOf: credentialsURL)
      credentials = try decoder.decode(InstabugCredentials.self, from: credentialsData)
    } catch {
      os_log(
        "Exception thrown while trying to create InstabugCredentials: %{public}s",
        log: OSLog.instabugCredentials,
        type: .error,
        error.localizedDescription
      )
      throw CredentialsError.couldNotCreate
    }

    return credentials
  }
}

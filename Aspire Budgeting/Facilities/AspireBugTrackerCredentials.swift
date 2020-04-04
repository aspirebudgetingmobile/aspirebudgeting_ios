//
//  InstabugCredentials.swift
//  Aspire Budgeting
//
//  Created by TeraMo Labs on 3/5/20.
//  Copyright © 2020 TeraMo Labs. All rights reserved.
//

import Foundation
import os.log

struct AspireBugTrackerCredentials: Codable {
  let live: String
  
  static func getCredentials(from fileName: String = "bugsnag",
                             type: String = "plist",
                             bundle: Bundle = Bundle.main,
                             decoder: PropertyListDecoder = PropertyListDecoder()) throws -> AspireBugTrackerCredentials {
    var credentialsData: Data
    var credentials: AspireBugTrackerCredentials
    
    guard let credentialsURL = bundle.url(forResource: fileName, withExtension: type) else {
      os_log("bugsnag.plist file not found.",
             log: OSLog.bugTrackerCredentials,
             type: .error)
      throw CredentialsError.missingCredentialsPLIST
    }
    
    do {
      credentialsData = try Data(contentsOf: credentialsURL)
      credentials = try decoder.decode(AspireBugTrackerCredentials.self, from: credentialsData)
    } catch {
      os_log("Exception thrown while trying to create InstabugCredentials: %{public}s",
             log: OSLog.bugTrackerCredentials,
             type: .error,
             error.localizedDescription)
      throw CredentialsError.couldNotCreate
    }
    
    return credentials
  }
}

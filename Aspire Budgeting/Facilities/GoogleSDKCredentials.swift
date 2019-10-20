//
//  GoogleSDKCredentials.swift
//  Aspire Budgeting
//
//  Created by TeraMo Labs on 10/19/19.
//  Copyright © 2019 TeraMo Labs. All rights reserved.
//

import Foundation

struct GoogleSDKCredentials: Codable {
  var CLIENT_ID: String
  var REVERSED_CLIENT_ID: String
  
  static func getCredentials() -> GoogleSDKCredentials? {
    let credentialsFileName = "credentials"
    let credentialsFileType = "plist"
    let bundle = Bundle.main
    
    guard let credentialsURL = bundle.url(forResource: credentialsFileName,
                                          withExtension: credentialsFileType),
      let credentialsData = try? Data(contentsOf: credentialsURL)
      else {
        return nil
    }
    
    let decoder = PropertyListDecoder()
    return try? decoder.decode(GoogleSDKCredentials.self,
                                          from: credentialsData)
  }
}

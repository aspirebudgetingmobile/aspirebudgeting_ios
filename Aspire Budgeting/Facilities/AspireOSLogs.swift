//
//  AspireOSLogs.swift
//  Aspire Budgeting
//
//  Created by TeraMo Labs on 1/3/20.
//  Copyright © 2020 TeraMo Labs. All rights reserved.
//

import Foundation
import os.log

extension OSLog {
  private static var subsystem = Bundle.main.bundleIdentifier!
  
  static let googleSDKCredentials = OSLog(subsystem: subsystem, category: "GoogleSDKCredentials")
  
  static let userManager = OSLog(subsystem: subsystem, category: "UserManager")
  
  static let sheetsManager = OSLog(subsystem: OSLog.subsystem, category: "SheetsManager")
  
}

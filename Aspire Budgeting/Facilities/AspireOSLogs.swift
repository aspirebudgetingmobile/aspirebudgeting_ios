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

  static let instabugCredentials = OSLog(subsystem: subsystem, category: "InstabugCredentials")

  static let userManager = OSLog(subsystem: subsystem, category: "UserManager")

  static let googleDriveManager = OSLog(subsystem: subsystem, category: "GoogleDriveManager")

  static let sheetsManager = OSLog(subsystem: OSLog.subsystem, category: "SheetsManager")

  static let localAuthorizationManager = OSLog(
    subsystem: OSLog.subsystem,
    category: "LocalAuthorizationManager"
  )

  static let stateManager = OSLog(subsystem: OSLog.subsystem, category: "StateManager")

  static let dashboardMetadata = OSLog(subsystem: OSLog.subsystem, category: "DashboardMetadata")
}

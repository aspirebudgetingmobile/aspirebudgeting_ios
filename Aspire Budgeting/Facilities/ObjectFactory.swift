//
//  ObjectFactory.swift
//  Aspire Budgeting
//
//  Created by TeraMo Labs on 10/22/19.
//  Copyright © 2019 TeraMo Labs. All rights reserved.
//

import Foundation
import GoogleSignIn

final class ObjectFactory {
  private let credentialsFileName = "credentials"

  lazy var googleSDKCredentials: GoogleSDKCredentials! = {
    var sdkCredentials: GoogleSDKCredentials?

    do {
      sdkCredentials = try GoogleSDKCredentials.getCredentials(
        from: credentialsFileName,
        type: "plist",
        bundle: Bundle.main,
        decoder: PropertyListDecoder()
      )
    } catch {
      fatalError("Unable to instantiate GoogleSDKCredentials.")
    }

    return sdkCredentials!
  }()

  lazy var instabugCredentials: InstabugCredentials! = {
    var instabugCredentials: InstabugCredentials

    do {
      instabugCredentials = try InstabugCredentials.getCredentials()
    } catch {
      fatalError("Unable to instantiate InstabugCredentials")
    }

    return instabugCredentials
  }()

  lazy var userManager: UserManager = {
    UserManager<GIDGoogleUser>(credentials: googleSDKCredentials)
  }()

  lazy var driveManager: GoogleDriveManager = {
    let driveManager = GoogleDriveManager()
    return driveManager
  }()

  lazy var sheetsManager: GoogleSheetsManager = {
    let sheetsManager = GoogleSheetsManager()
    return sheetsManager
  }()

  lazy var localAuthorizationManager: LocalAuthorizationManager = {
    let localAuthManager = LocalAuthorizationManager()
    return localAuthManager
  }()

  lazy var stateManager: StateManager = {
    StateManager()
  }()

  lazy var bugTracker: AspireBugTracker = {
    AspireBugTracker(credentials: instabugCredentials)
  }()
}

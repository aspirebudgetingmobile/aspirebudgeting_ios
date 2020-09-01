//
//  ObjectFactory.swift
//  Aspire Budgeting
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

  lazy var userManager: GoogleUserManager = {
    GoogleUserManager(credentials: googleSDKCredentials)
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

  lazy var appDefaultsManager: AppDefaultsManager = {
    AppDefaultsManager()
  }()

  lazy var googleValidator: GoogleSheetsValidator = {
    GoogleSheetsValidator()
  }()

  lazy var appCoordinator: AppCoordinator = {
    AppCoordinator(stateManager: stateManager,
                   localAuthorizer: localAuthorizationManager,
                   appDefaults: appDefaultsManager,
                   remoteFileManager: driveManager,
                   userManager: userManager,
                   fileValidator: googleValidator)
  }()
}

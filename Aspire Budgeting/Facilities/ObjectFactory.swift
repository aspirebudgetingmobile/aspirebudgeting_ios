//
//  ObjectFactory.swift
//  Aspire Budgeting
//
//  Created by TeraMo Labs on 10/22/19.
//  Copyright © 2019 TeraMo Labs. All rights reserved.
//

import Foundation
import GoogleSignIn

/// `NewObjectFactory` (name will change)
protocol NewObjectFactory {
  var driveManager: DriveManager { get }
}

final class PreviewProviderObjectFactory: NewObjectFactory {
  lazy var driveManager: DriveManager = {
    PreviewDriveManager()
  }()
}

final class PreviewDriveManager: DriveManager {
  private let files: [File] = [
    File(id: UUID().uuidString, name: "Preview File 1"),
    File(id: UUID().uuidString, name: "Preview File 2"),
    File(id: UUID().uuidString, name: "Preview File 3"),
    File(id: UUID().uuidString, name: "Aspire Budget v3.2"),
    File(id: UUID().uuidString, name: "Preview File 4"),
  ]

  // The error one might want to show in the preview canvas.
  var error: AspireError?

  func getFilesList(completion: @escaping (Result<[File]>) -> Void) {
    if let error = error {
      completion(.error(error))
    } else {
      completion(.success(files))
    }
  }

  func cancelGetFilesListRequest() {
    // Nothing to cancel
  }

}

//
final class ObjectFactory: NewObjectFactory {
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

  lazy var driveManager: DriveManager = {
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

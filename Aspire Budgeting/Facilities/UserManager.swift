//
//  UserManager.swift
//  Aspire Budgeting
//
//  Created by TeraMo Labs on 10/20/19.
//  Copyright © 2019 TeraMo Labs. All rights reserved.
//

import Foundation
import GoogleSignIn
import Combine
import GoogleAPIClientForREST
import GTMSessionFetcher

protocol AspireSignInInstance: AnyObject {
  var clientID: String! {get set}
  var delegate: GIDSignInDelegate! { get set }
  var scopes: [Any]! { get set }
  func restorePreviousSignIn()
  func signOut()
}

extension GIDSignIn: AspireSignInInstance {}

class UserManager: NSObject, GIDSignInDelegate, ObservableObject {
  private var isGoogleSDKSetup = false
  private let gidSignInInstance: AspireSignInInstance
  private let credentials: GoogleSDKCredentials
  
  @Published public private(set) var user: User?
  @Published public private(set) var error: Error?
  
  init(credentials: GoogleSDKCredentials,
       gidSignInInstance: AspireSignInInstance = GIDSignIn.sharedInstance()) {
    self.credentials = credentials
    self.gidSignInInstance = gidSignInInstance
  }
  
  func fetchUser() {
    gidSignInInstance.clientID = credentials.CLIENT_ID
    gidSignInInstance.delegate = self
    gidSignInInstance.scopes = [kGTLRAuthScopeDrive, kGTLRAuthScopeSheetsDrive]
    gidSignInInstance.restorePreviousSignIn()
  }
  
  func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
            withError error: Error!) {
    
    if let error = error {
      self.error = error
      if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
        print("The user has not signed in before or they have since signed out.")
      } else {
        print("\(error.localizedDescription)")
      }
      return
    }
    
    self.user = User(googleUser: user)
  }
  
  func signOut() {
    gidSignInInstance.signOut()
    self.user = nil
  }
}

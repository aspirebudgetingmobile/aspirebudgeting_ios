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

class UserManager: NSObject, GIDSignInDelegate, ObservableObject {
  private var isGoogleSDKSetup = false
  private let gidSignInInstance: GIDSignIn! = GIDSignIn.sharedInstance()
  private let credentials: GoogleSDKCredentials
  
  @Published public private(set) var user: User?
  
  init(credentials: GoogleSDKCredentials) {
    self.credentials = credentials
  }
  
  func fetchUser() {
    if !isGoogleSDKSetup
      {
      GIDSignIn.sharedInstance().clientID = credentials.CLIENT_ID
      GIDSignIn.sharedInstance().delegate = self
      GIDSignIn.sharedInstance()?.scopes = [kGTLRAuthScopeDrive, kGTLRAuthScopeSheetsDrive]
      GIDSignIn.sharedInstance()?.restorePreviousSignIn()
      isGoogleSDKSetup.toggle()
    }
  }
  
  func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
            withError error: Error!) {
    
    if let error = error {
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
    GIDSignIn.sharedInstance()?.signOut()
    self.user = nil
  }
}

//
//  UserManager.swift
//  Aspire Budgeting
//
//  Created by TeraMo Labs on 10/20/19.
//  Copyright © 2019 TeraMo Labs. All rights reserved.
//

import Combine
import Foundation
import GoogleAPIClientForREST
import GoogleSignIn
import GTMSessionFetcher

protocol AspireSignInInstance: AnyObject {
  var clientID: String! {get set}
  var delegate: GIDSignInDelegate! { get set }
  var scopes: [Any]! { get set }
  func restorePreviousSignIn()
  func signOut()
}

extension GIDSignIn: AspireSignInInstance {}

extension Notification.Name {
  static let authorizerUpdated = Notification.Name("authorizerUpdated")
}

protocol AspireNotificationCenter: AnyObject {
  func post(name aName: NSNotification.Name, object anObject: Any?, userInfo aUserInfo: [AnyHashable: Any]?)
}

extension NotificationCenter: AspireNotificationCenter {}

final class UserManager<U: AspireUser>: NSObject, GIDSignInDelegate, ObservableObject {
  private let gidSignInInstance: AspireSignInInstance
  private let credentials: GoogleSDKCredentials
  private let notificationCenter: AspireNotificationCenter
  private let localAuthManager = LocalAuthorizationManager()
  
  private var isFreshSignIn = false
  
  @Published public private(set) var userAuthenticated = false
  @Published public private(set) var user: User?
  @Published public private(set) var error: Error?
  
  init(credentials: GoogleSDKCredentials,
       gidSignInInstance: AspireSignInInstance = GIDSignIn.sharedInstance(),
       notificationCenter: AspireNotificationCenter = NotificationCenter.default) {
    self.credentials = credentials
    self.gidSignInInstance = gidSignInInstance
    self.notificationCenter = notificationCenter
  }
  
  var subscription: AnyCancellable!
  
  func authenticateWithGoogle() {
    fetchUser()
  }
  
  func authenticateLocally() {
    localAuthManager.authenticateUserLocally()
  }
  
  private func fetchUser() {
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
        isFreshSignIn = true
        print("The user has not signed in before or they have since signed out.")
      } else {
        print("\(error.localizedDescription)")
      }
      return
    }
    
    self.signIn(user: user)
  }
  
  func signIn<U: AspireUser>(user: U) {
    self.user = User(googleUser: user, isFresh: isFreshSignIn)
    notificationCenter.post(name: Notification.Name.authorizerUpdated, object: self, userInfo: [Notification.Name.authorizerUpdated: self.user!.authorizer])
  }
  
  func signOut() {
    gidSignInInstance.signOut()
    localAuthManager.signOut()
    userAuthenticated = false
    self.user = nil
  }
}

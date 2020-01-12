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
import os.log

protocol AspireSignInInstance: AnyObject {
  var clientID: String! {get set}
  var delegate: GIDSignInDelegate! { get set }
  var presentingViewController: UIViewController! { get set }
  var scopes: [Any]! { get set }
  func restorePreviousSignIn()
  func signOut()
  func signIn()
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
    os_log("Attempting to authenticate with Google",
           log: .userManager,
           type: .default)
    fetchUser()
  }
  
  func signInWithGoogle(in presentingViewController: UIViewController?) {
    guard let presentingVC = presentingViewController else {
      return
    }
    
    self.gidSignInInstance.presentingViewController = presentingVC
    self.gidSignInInstance.signIn()
  }
  
  func authenticateLocally() {
    os_log("Attempting to authenticate user locally",
           log: .userManager,
           type: .default)
    localAuthManager.authenticateUserLocally()
  }
  
  private func fetchUser() {
    os_log("Attempting to restore previous Google SignIn",
           log: .userManager,
           type: .default)
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
        os_log("The user has not signed in before or has since signed out. Proceed with normal sign in flow.",
               log: .userManager,
               type: .default)
      } else {
        os_log("A generic error occured. %{public}s",
               log: .userManager,
               type: .default,
               error.localizedDescription)
      }
      return
    }
    
    self.signIn(user: user)
  }
  
  func signIn<U: AspireUser>(user: U) {
    os_log("User authenticated with Google successfully.",
           log: .userManager, type: .default)
    
    self.user = User(googleUser: user)
    notificationCenter.post(name: Notification.Name.authorizerUpdated, object: self, userInfo: [Notification.Name.authorizerUpdated: self.user!.authorizer])
  }
  
  func signOut() {
    gidSignInInstance.signOut()
    userAuthenticated = false
    self.user = nil
    
    os_log("Logging out user from Google and locally",
           log: .userManager, type: .default)
  }
}

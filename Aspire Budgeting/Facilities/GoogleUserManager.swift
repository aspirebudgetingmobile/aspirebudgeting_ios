//
//  UserManager.swift
//  Aspire Budgeting
//

import Combine
import Foundation
import GoogleAPIClientForREST
import GoogleSignIn
import GTMSessionFetcher
import os.log

protocol IGIDSignIn: AnyObject {
  var clientID: String! { get set }
  var delegate: GIDSignInDelegate! { get set }
  var presentingViewController: UIViewController! { get set }
  var scopes: [Any]! { get set }
  func restorePreviousSignIn()
  func signOut()
  func signIn()
}

extension GIDSignIn: IGIDSignIn {}

//TODO: Remove NotificationCenter extensions
extension Notification.Name {
  static let authorizerUpdated = Notification.Name("authorizerUpdated")

  static let logout = Notification.Name("logout")
}

protocol AspireNotificationCenter: AnyObject {
  func post(
    name aName: NSNotification.Name,
    object anObject: Any?,
    userInfo aUserInfo: [AnyHashable: Any]?
  )
}

extension NotificationCenter: AspireNotificationCenter {}

enum UserManagerState {
  case notAuthenticated
  case authenticated(User)
  case error(Error)
}

protocol UserManager {
  var currentState: CurrentValueSubject<UserManagerState, Never> { get }
  func authenticateWithService()
}

//TODO: Remove conformance to ObservableObject
final class GoogleUserManager: NSObject, GIDSignInDelegate, UserManager, ObservableObject {
  private let gidSignInInstance: IGIDSignIn
  private let credentials: GoogleSDKCredentials

  private(set) var currentState =
    CurrentValueSubject<UserManagerState, Never>(.notAuthenticated)

  init(
    credentials: GoogleSDKCredentials,
    gidSignInInstance: IGIDSignIn = GIDSignIn.sharedInstance()
  ) {
    self.credentials = credentials
    self.gidSignInInstance = gidSignInInstance
  }

  func authenticateWithService() {
    os_log(
      "Attempting to authenticate with Google",
      log: .userManager,
      type: .default
    )
    fetchUser()
  }

  private func fetchUser() {
    os_log(
      "Attempting to restore previous Google SignIn",
      log: .userManager,
      type: .default
    )
    gidSignInInstance.clientID = credentials.CLIENT_ID
    gidSignInInstance.delegate = self
    gidSignInInstance.scopes = [kGTLRAuthScopeDrive, kGTLRAuthScopeSheetsDrive]
    gidSignInInstance.restorePreviousSignIn()
  }

  func sign(
    _ signIn: GIDSignIn!,
    didSignInFor user: GIDGoogleUser!,
    withError error: Error!
  ) {
    if let error = error {
      self.currentState.value = .error(error)
      if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
        os_log(
          // swiftlint:disable line_length
          "The user has not signed in before or has since signed out. Proceed with normal sign in flow.",
          // swiftlint:enable line_length
          log: .userManager,
          type: .default
        )
      } else {
        os_log(
          "A generic error occured. %{public}s",
          log: .userManager,
          type: .default,
          error.localizedDescription
        )
      }
      return
    }

    self.signIn(user: user)
  }

  private func signIn(user: GIDGoogleUser) {
    os_log(
      "User authenticated with Google successfully.",
      log: .userManager,
      type: .default
    )

    let user = User(name: user.profile.name,
                    authorizer: user.authentication.fetcherAuthorizer())
    self.currentState.value = .authenticated(user)
  }

  func signOut() {
    gidSignInInstance.signOut()
    currentState.value = .notAuthenticated

    os_log(
      "Logging out user from Google and locally",
      log: .userManager,
      type: .default
    )
    self.currentState.value = .notAuthenticated
  }
}

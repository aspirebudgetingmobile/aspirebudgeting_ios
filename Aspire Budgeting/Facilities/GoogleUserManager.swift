//
//  UserManager.swift
//  Aspire Budgeting
//

import Combine
import Foundation
import GoogleAPIClientForREST
import GoogleSignIn
import GTMSessionFetcher

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
  func authenticate() -> AnyPublisher<Result<User>, Never>
}

final class GoogleUserManager: NSObject, GIDSignInDelegate, UserManager {
  private let gidSignInInstance: IGIDSignIn
  private let credentials: GoogleSDKCredentials

  private let userSubject = PassthroughSubject<Result<User>, Never>()

  init(
    credentials: GoogleSDKCredentials,
    gidSignInInstance: IGIDSignIn = GIDSignIn.sharedInstance()
  ) {
    self.credentials = credentials
    self.gidSignInInstance = gidSignInInstance
  }

  func authenticate() -> AnyPublisher<Result<User>, Never> {
    Logger.info(
      "Attempting to authenticate with Google"
    )
    fetchUser()
    return userSubject.eraseToAnyPublisher()
  }

  private func fetchUser() {
    Logger.info(
      "Attempting to restore previous Google SignIn"
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
      if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
        Logger.info(
          // swiftlint:disable line_length
          "The user has not signed in before or has since signed out. Proceed with normal sign in flow."
          // swiftlint:enable line_length
        )
      } else {
        Logger.error(
          "A generic error occured. %{public}s",
          context: error.localizedDescription
        )
        userSubject.send(.failure(error))
      }
      return
    }

    self.signIn(user: user)
  }

  private func signIn(user: GIDGoogleUser) {
    Logger.info(
      "User authenticated with Google successfully."
    )

    let user = User(name: user.profile.name,
                    authorizer: user.authentication.fetcherAuthorizer())
    self.userSubject.send(.success(user))
  }

  func signOut() {
    gidSignInInstance.signOut()

    Logger.info(
      "Logging out user from Google and locally"
    )
  }
}

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
  var userPublisher: AnyPublisher<Result<User>, Never> { get }
  func authenticate()
}

final class GoogleUserManager: NSObject, GIDSignInDelegate, UserManager {
  private var user: User?

  private let gidSignInInstance: IGIDSignIn
  private let credentials: GoogleSDKCredentials

  private let userSubject = CurrentValueSubject<Result<User>?, Never>(nil)
  var userPublisher: AnyPublisher<Result<User>, Never> {
    userSubject
      .compactMap { result in
        guard let result = result else { return nil }
        return result
      }
      .eraseToAnyPublisher()
  }

  init(
    credentials: GoogleSDKCredentials,
    gidSignInInstance: IGIDSignIn = GIDSignIn.sharedInstance()
  ) {
    self.credentials = credentials
    self.gidSignInInstance = gidSignInInstance
  }

  func authenticate() {
    Logger.info(
      "Attempting to authenticate with Google"
    )
    fetchUser()
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
        userSubject.value = .failure(error)
      }
      return
    }

    self.signIn(user: user)
  }

  private func signIn(user gUser: GIDGoogleUser) {
    Logger.info(
      "User authenticated with Google successfully."
    )

    let user = User(name: gUser.profile.name,
                    authorizer: gUser.authentication.fetcherAuthorizer())

    self.user = user
    userSubject.value = .success(user)
  }

  func signOut() {
    gidSignInInstance.signOut()

    Logger.info(
      "Logging out user from Google and locally"
    )
  }
}

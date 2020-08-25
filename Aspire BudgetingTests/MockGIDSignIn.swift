//
//  Mocks.swift
//  Aspire BudgetingTests
//

@testable import Aspire_Budgeting
import Foundation
import GoogleSignIn

final class MockGIDSignIn: IGIDSignIn {
  var presentingViewController: UIViewController!

  var signInCalled = false
  func signIn() {
    signInCalled = true
  }

  var clientID: String!
  weak var delegate: GIDSignInDelegate!
  var scopes: [Any]!

  var restoreCalled = false
  func restorePreviousSignIn() {
    restoreCalled = true
  }

  var signOutCalled = false
  func signOut() {
    signOutCalled = true
  }
}

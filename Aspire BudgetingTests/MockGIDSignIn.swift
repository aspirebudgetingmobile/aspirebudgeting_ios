//
//  Mocks.swift
//  Aspire BudgetingTests
//
//  Created by TeraMo Labs on 11/1/19.
//  Copyright © 2019 TeraMo Labs. All rights reserved.
//

@testable import Aspire_Budgeting
import Foundation
import GoogleSignIn

final class MockGIDSignIn: AspireSignInInstance {
  var presentingViewController: UIViewController!
  
  func signIn() {
    
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

//
//  UserManagerTests.swift
//  Aspire BudgetingTests
//
//  Created by TeraMo Labs on 10/22/19.
//  Copyright © 2019 TeraMo Labs. All rights reserved.
//

import GoogleAPIClientForREST
import GoogleSignIn
import XCTest

@testable import Aspire_Budgeting

class MockGIDSignIn: AspireSignInInstance {
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

class UserManagerTests: XCTestCase {
  let mockGoogleCredentials = GoogleSDKCredentials(CLIENT_ID: "dummy_client", REVERSED_CLIENT_ID: "client_dummy")
  let mockGIDSignIn = MockGIDSignIn()
  
  lazy var userManager = UserManager(credentials: mockGoogleCredentials, gidSignInInstance: mockGIDSignIn)
  
  override func setUp() {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    mockGIDSignIn.clientID = mockGoogleCredentials.CLIENT_ID
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  func testFetchUser() {
    userManager.fetchUser()
    XCTAssertEqual(mockGIDSignIn.clientID, mockGoogleCredentials.CLIENT_ID)
    XCTAssertTrue(userManager === mockGIDSignIn.delegate)
    XCTAssertNotNil(mockGIDSignIn.scopes as? [String])
    XCTAssertEqual(mockGIDSignIn.scopes as! [String], [kGTLRAuthScopeSheetsSpreadsheets])
    XCTAssertTrue(mockGIDSignIn.restoreCalled)
    
    let expectation = XCTestExpectation()
    _ = userManager.$user.sink { (user) in
      if user == nil {
        expectation.fulfill()
      } else {
        XCTFail("Expected \"user\" to be nil")
      }
    }
  }
  
  func testSignIn() {
    let dummyUser = GIDGoogleUser()
    
    userManager.sign(nil, didSignInFor: dummyUser, withError: nil)
    
    let expectation = XCTestExpectation()
    _ = userManager.$user.sink { (user) in
      if user != nil {
        expectation.fulfill()
      } else {
        XCTFail("Expected \"user\" to ba a valid instance")
      }
    }
  }
  
  func testSignInPublishesNoUserError() {
    let error = NSError(domain: "Test",
                        code: GIDSignInErrorCode.hasNoAuthInKeychain.rawValue,
                        userInfo: nil)
    
    userManager.sign(nil, didSignInFor: nil, withError: error)
    
    let expectation = XCTestExpectation()
    _ = userManager.$error.sink { (error) in
      XCTAssertNotNil(error)
      XCTAssertEqual(GIDSignInErrorCode.hasNoAuthInKeychain.rawValue, (error! as NSError).code)
      expectation.fulfill()
  }
  }
  
  func testSignOut() {
    userManager.signOut()
    
    XCTAssertTrue(mockGIDSignIn.signOutCalled)
    
    let expectation = XCTestExpectation()
    _ = userManager.$user.sink { (user) in
      if user == nil {
        expectation.fulfill()
      } else {
        XCTFail("Expected \"user\" to be nil")
      }
    }
  }
}

//
//  UserManagerTests.swift
//  Aspire BudgetingTests
//

import GoogleAPIClientForREST
import GoogleSignIn
import GTMSessionFetcher
import XCTest

@testable import Aspire_Budgeting

final class UserManagerTests: XCTestCase {
  let mockGoogleCredentials = GoogleSDKCredentials(
    CLIENT_ID: "dummy_client",
    REVERSED_CLIENT_ID: "client_dummy"
  )

  let mockGIDSignIn = MockGIDSignIn()

  lazy var userManager = GoogleUserManager(
    credentials: mockGoogleCredentials,
    gidSignInInstance: mockGIDSignIn
  )

  override func setUp() {
    super.setUp()
    mockGIDSignIn.clientID = mockGoogleCredentials.CLIENT_ID
  }

  func testAuthenticateWithService() {
    userManager.authenticate()
    XCTAssertEqual(mockGIDSignIn.clientID, mockGoogleCredentials.CLIENT_ID)
    XCTAssertTrue(userManager === mockGIDSignIn.delegate)
    XCTAssertNotNil(mockGIDSignIn.scopes as? [String])
    XCTAssertEqual(
      mockGIDSignIn.scopes as! [String],
      [
        kGTLRAuthScopeDrive,
        kGTLRAuthScopeSheetsDrive,
      ]
    )
    XCTAssertTrue(mockGIDSignIn.restoreCalled)
  }

  func testSignIn() {
    let mockUser = MockUser()
    userManager.sign(nil, didSignInFor: mockUser, withError: nil)

    let exp = XCTestExpectation()
    _ = userManager
      .userPublisher
      .compactMap { $0 }
      .sink { user in
        XCTAssertEqual(user.name, mockUser.profile.name)
        exp.fulfill()
      }

    wait(for: [exp], timeout: 1)
  }

  func testSignOut() {
    userManager.signOut()

    XCTAssertTrue(mockGIDSignIn.signOutCalled)

    let exp = XCTestExpectation()
    _ = userManager
      .userPublisher
      .sink { user in
        XCTAssertNil(user)
        exp.fulfill()
      }
    wait(for: [exp], timeout: 1)
  }
}

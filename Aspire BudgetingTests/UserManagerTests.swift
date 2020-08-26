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
    userManager.authenticateWithService()
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

    let expectation = XCTestExpectation()
    _ = userManager.currentState.sink { state in
      switch state {
      case .notAuthenticated:
        expectation.fulfill()
      default:
        XCTFail("Expected state to be .notAuthenticated")
      }
    }
  }

  func testSignInPublishesNoUserError() {
    let error = NSError(
      domain: "Test",
      code: GIDSignInErrorCode.hasNoAuthInKeychain.rawValue,
      userInfo: nil
    )

    userManager.sign(nil, didSignInFor: nil, withError: error)

    let expectation = XCTestExpectation()
    _ = userManager.currentState.sink { state in
      switch state {
      case .error(let error):
      print(error)
        XCTAssertEqual(GIDSignInErrorCode.hasNoAuthInKeychain.rawValue, (error as NSError).code)
        expectation.fulfill()
      default:
        XCTFail()
      }
    }
  }

  func testSignIn() {
    let mockUser = MockUser()
    userManager.sign(nil, didSignInFor: mockUser, withError: nil)

    let expectation = XCTestExpectation()
    _ = userManager.currentState.sink { state in
      switch state {
      case .authenticated(let user):
        XCTAssertEqual(user.name, mockUser.profile.name)
        expectation.fulfill()
      default:
        XCTFail()
      }
    }
  }

  func testSignOut() {
    userManager.signOut()

    XCTAssertTrue(mockGIDSignIn.signOutCalled)

    let expectation = XCTestExpectation()
    _ = userManager.currentState.sink { state in
      switch state {
      case .notAuthenticated:
        expectation.fulfill()
      default:
        XCTFail("Expected state to be notAuthenticated.")
      }
    }
  }
}

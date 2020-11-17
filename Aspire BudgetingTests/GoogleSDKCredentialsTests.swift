//
//  GoogleSDKCredentialsTest.swift
//  Aspire BudgetingTests
//

@testable import Aspire_Budgeting
import XCTest

class GoogleSDKCredentialsTests: XCTestCase {
  var testBundle: Bundle {
    Bundle(for: type(of: self))
  }

  let decoder = PropertyListDecoder()

  func testGetCredentialsNoThrow() {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    let fileName = "credentials"
    let type = "plist"

    XCTAssertNoThrow(
      try GoogleSDKCredentials.getCredentials(
        from: fileName,
        type: type,
        bundle: testBundle,
        decoder: decoder
      )
    )
  }

  func testGetCredentialsThrowsMissingCredentialsPLIST() {
    XCTAssertThrowsError(
      try GoogleSDKCredentials.getCredentials(
        from: "no_file",
        type: "plist",
        bundle: testBundle,
        decoder: decoder
      ),
      ""
    ) { error in
      guard let error = error as? CredentialsError else {
        XCTFail("Type of error thrown is incorrect")
        return
      }

      XCTAssertEqual(error, CredentialsError.missingCredentialsPLIST)
    }
  }

  func testGetCredentialsThrowsCouldNotCreate() {
    XCTAssertThrowsError(
      try GoogleSDKCredentials.getCredentials(
        from: "bad_credentials",
        type: "plist",
        bundle: testBundle,
        decoder: decoder
      ),
      ""
    ) { error in
      guard let error = error as? CredentialsError else {
        XCTFail("Type of error thrown is incorrect")
        return
      }

      XCTAssertEqual(error, CredentialsError.couldNotCreate)
    }
  }

//  func testGoogleSDKErrorEquality() {
//    XCTAssertEqual(
//      CredentialsError.missingCredentialsPLIST,
//      CredentialsError.missingCredentialsPLIST
//    )
//    XCTAssertEqual(CredentialsError.couldNotCreate, CredentialsError.couldNotCreate)
//    XCTAssertNotEqual(
//      GoogleSDKCredentialsError.missingCredentialsPLIST,
//      GoogleSDKCredentialsError.couldNotCreate
//    )
//  }
}

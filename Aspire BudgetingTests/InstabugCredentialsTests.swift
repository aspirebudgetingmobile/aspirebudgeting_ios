//
//  InstabugCredentialsTests.swift
//  Aspire BudgetingTests
//

@testable import Aspire_Budgeting
import XCTest

final class InstabugCredentialsTests: XCTestCase {
  var testBundle: Bundle {
    Bundle(for: type(of: self))
  }

  let decoder = PropertyListDecoder()

  func testThrowsMissingCredentials() {
    XCTAssertThrowsError(
      try InstabugCredentials.getCredentials(
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

  func testThrowsCouldNotCreate() {
    XCTAssertThrowsError(
      try InstabugCredentials.getCredentials(
        from: "bad_instabug",
        type: "plist",
        bundle: testBundle,
        decoder: decoder
      ),
      ""
    ) { error in
      guard let error = error as? CredentialsError else {
        XCTFail("Type of errror thrown is incorrect")
        return
      }

      XCTAssertEqual(error, CredentialsError.couldNotCreate)
    }
  }
}

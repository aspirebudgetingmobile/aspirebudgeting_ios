//
//  GoogleSDKCredentialsTest.swift
//  Aspire BudgetingTests
//
//  Created by TeraMo Labs on 10/22/19.
//  Copyright © 2019 TeraMo Labs. All rights reserved.
//

import XCTest
@testable import Aspire_Budgeting

class GoogleSDKCredentialsTests: XCTestCase {
  
  var testBundle: Bundle {
    Bundle(for: type(of: self))
  }
  
  let decoder = PropertyListDecoder()
  override func setUp() {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  func testGetCredentialsNoThrow() {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    let fileName = "credentials"
    let type = "plist"
    
    XCTAssertNoThrow(try GoogleSDKCredentials
      .getCredentials(from: fileName,
                      type: type,
                      bundle: testBundle,
                      decoder: decoder))
  }
  
  func testGetCredentialsThrowsMissingCredentialsPLIST() {
    XCTAssertThrowsError(try GoogleSDKCredentials
      .getCredentials(from: "no_file",
                      type: "plist",
                      bundle: testBundle,
                      decoder: decoder), "") { (error) in
        guard let error = error as? GoogleSDKCredentialsError else {
          XCTFail("Type of error thrown is incorrect")
          return
        }
        
        XCTAssertEqual(error, GoogleSDKCredentialsError.missingCredentialsPLIST)
    }
  }
  
  func testGetCredentialsThrowsCouldNotCreate() {
    XCTAssertThrowsError(try GoogleSDKCredentials
      .getCredentials(from: "bad_credentials",
                      type: "plist",
                      bundle: testBundle,
                      decoder: decoder), "") { (error) in
      guard let error = error as? GoogleSDKCredentialsError else {
        XCTFail("Type of error thrown is incorrect")
        return
      }
      
      XCTAssertEqual(error, GoogleSDKCredentialsError.couldNotCreate)
    }
  }
  
  func testGoogleSDKErrorEquality() {
    XCTAssertEqual(GoogleSDKCredentialsError.missingCredentialsPLIST, GoogleSDKCredentialsError.missingCredentialsPLIST)
    XCTAssertEqual(GoogleSDKCredentialsError.couldNotCreate, GoogleSDKCredentialsError.couldNotCreate)
    XCTAssertNotEqual(GoogleSDKCredentialsError.missingCredentialsPLIST, GoogleSDKCredentialsError.couldNotCreate)
  }
}

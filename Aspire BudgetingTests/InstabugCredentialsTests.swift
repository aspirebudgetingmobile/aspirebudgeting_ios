//
//  InstabugCredentialsTests.swift
//  Aspire BudgetingTests
//
//  Created by TeraMo Labs on 3/6/20.
//  Copyright © 2020 TeraMo Labs. All rights reserved.
//

@testable import Aspire_Budgeting
import XCTest

final class InstabugCredentialsTests: XCTestCase {
  
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
  
  func testThrowsMissingCredentials() {
    XCTAssertThrowsError(try InstabugCredentials
      .getCredentials(from: "no_file",
                      type: "plist",
                      bundle: testBundle,
                      decoder: decoder), "") { (error) in
                        guard let error = error as? CredentialsError else {
                          XCTFail("Type of error thrown is incorrect")
                          return
                        }
                        
                        XCTAssertEqual(error, CredentialsError.missingCredentialsPLIST)
    }
  }
  
  func testThrowsCouldNotCreate() {
    XCTAssertThrowsError(try InstabugCredentials
      .getCredentials(from: "bad_instabug",
                      type: "plist",
                      bundle: testBundle,
                      decoder: decoder), "") { (error) in
                        guard let error = error as? CredentialsError else {
                          XCTFail("Type of errror thrown is incorrect")
                          return
                        }
                        
                        XCTAssertEqual(error, CredentialsError.couldNotCreate)
    }
  }
  
}

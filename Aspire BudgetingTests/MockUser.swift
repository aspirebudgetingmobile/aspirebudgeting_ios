//
//  MockUser.swift
//  Aspire BudgetingTests
//
//  Created by TeraMo Labs on 11/1/19.
//  Copyright © 2019 TeraMo Labs. All rights reserved.
//

@testable import Aspire_Budgeting
import Foundation
import GTMSessionFetcher

class MockUser: AspireUser {
  typealias Profile = MockProfile
  
  typealias Authentication = MockAuthentication
  
  var profile: Profile! = MockProfile()
  var authentication: Authentication! = MockAuthentication()
  
}

class MockProfile: AspireProfile {
  var name: String! = "First Last"
}

class MockAuthentication: AspireAuthentication {
  var authorizer: GTMFetcherAuthorizationProtocol! = nil
  func fetcherAuthorizer() -> GTMFetcherAuthorizationProtocol! {
    if authorizer == nil {
      authorizer = MockAuthorizer()
    }
    return authorizer
  }
}

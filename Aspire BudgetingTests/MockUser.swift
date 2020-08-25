//
//  MockUser.swift
//  Aspire BudgetingTests
//
//  Created by TeraMo Labs on 11/1/19.
//  Copyright © 2019 TeraMo Labs. All rights reserved.
//

@testable import Aspire_Budgeting
import Foundation
import GoogleSignIn
import GTMSessionFetcher

final class MockUser: GoogleUserProtocol {
  typealias Profile = MockProfile

  typealias Authentication = MockAuthentication

  var profile: Profile! = MockProfile()
  var authentication: Authentication! = MockAuthentication()
}

final class MockProfile: GoogleProfileDataProtocol {
  var name: String! = "First Last"
}

final class MockAuthentication: GoogleAuthorizationProtocol {
  var authorizer: GTMFetcherAuthorizationProtocol!
  func fetcherAuthorizer() -> GTMFetcherAuthorizationProtocol! {
    if authorizer == nil {
      authorizer = MockAuthorizer()
    }
    return authorizer
  }
}

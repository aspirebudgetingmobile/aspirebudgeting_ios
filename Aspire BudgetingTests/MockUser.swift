//
//  MockUser.swift
//  Aspire BudgetingTests
//

@testable import Aspire_Budgeting
import Foundation
import GoogleSignIn
import GTMSessionFetcher

final class MockProfile: GIDProfileData {
  override var name: String! {
    "First Last"
  }
}

final class MockAuthentication: GIDAuthentication {
  override func fetcherAuthorizer() -> GTMFetcherAuthorizationProtocol! {
    MockAuthorizer()
  }
}

final class MockUser: GIDGoogleUser {
  override var profile: GIDProfileData! {
    MockProfile()
  }

  override var authentication: GIDAuthentication! {
    MockAuthentication()
  }
}

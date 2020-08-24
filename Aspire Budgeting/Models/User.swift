//
//  User.swift
//  Aspire Budgeting
//

import Foundation
import GoogleSignIn
import GTMSessionFetcher

//TODO: Remove these useless protocols and extensions
protocol AspireUser {
  associatedtype Profile: AspireProfile
  associatedtype Authentication: AspireAuthentication

  var profile: Profile! { get }
  var authentication: Authentication! { get }
}

protocol AspireProfile {
  var name: String! { get }
}

protocol AspireAuthentication {
  func fetcherAuthorizer() -> GTMFetcherAuthorizationProtocol!
}

extension GIDAuthentication: AspireAuthentication {}

extension GIDGoogleUser: AspireUser {
  typealias Profile = GIDProfileData

  typealias Authentication = GIDAuthentication
}

extension GIDProfileData: AspireProfile {}

struct User {
  let name: String
  let authorizer: AnyObject?

  init(name: String, authorizer: AnyObject?) {
    self.name = name
    self.authorizer = authorizer
  }
}

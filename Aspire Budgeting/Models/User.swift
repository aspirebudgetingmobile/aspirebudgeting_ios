//
//  User.swift
//  Aspire Budgeting
//

import Foundation
import GoogleSignIn
import GTMSessionFetcher

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

extension GIDAuthentication: AspireAuthentication { }

extension GIDGoogleUser: AspireUser {
  typealias Profile = GIDProfileData
  
  typealias Authentication = GIDAuthentication
}
extension GIDProfileData: AspireProfile {}

struct User {
  let name: String
  let authorizer: GTMFetcherAuthorizationProtocol
  let isFreshUser: Bool
  
  init<U>(googleUser: U, isFresh: Bool) where U: AspireUser {
    name = googleUser.profile.name
    authorizer = googleUser.authentication.fetcherAuthorizer()
    isFreshUser = isFresh
  }
}

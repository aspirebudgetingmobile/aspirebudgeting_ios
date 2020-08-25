//
// GoogleProtocolExtensions.swift
// Aspire Budgeting
//

import Foundation
import GoogleSignIn
import GTMSessionFetcher

protocol GoogleUserProtocol {
  associatedtype Profile: GoogleProfileDataProtocol
  associatedtype Authentication: GoogleAuthorizationProtocol

  var profile: Profile! { get }
  var authentication: Authentication! { get }
}

protocol GoogleProfileDataProtocol {
  var name: String! { get }
}
extension GIDProfileData: GoogleProfileDataProtocol {}

protocol GoogleAuthorizationProtocol {
  func fetcherAuthorizer() -> GTMFetcherAuthorizationProtocol!
}
extension GIDAuthentication: GoogleAuthorizationProtocol {}

extension GIDGoogleUser: GoogleUserProtocol {
  typealias Profile = GIDProfileData
  typealias Authentication = GIDAuthentication
}

//
//  User.swift
//  Aspire Budgeting
//

import Foundation
import GTMSessionFetcher

struct User {
  let name: String
  let authorizer: GTMFetcherAuthorizationProtocol

  init(name: String, authorizer: GTMFetcherAuthorizationProtocol) {
    self.name = name
    self.authorizer = authorizer
  }
}

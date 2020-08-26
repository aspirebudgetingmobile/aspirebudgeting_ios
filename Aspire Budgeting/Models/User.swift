//
//  User.swift
//  Aspire Budgeting
//

import Foundation

struct User {
  let name: String
  let authorizer: AnyObject?

  init(name: String, authorizer: AnyObject?) {
    self.name = name
    self.authorizer = authorizer
  }
}

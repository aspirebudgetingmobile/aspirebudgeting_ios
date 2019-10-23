//
//  User.swift
//  Aspire Budgeting
//

import Foundation
import GoogleSignIn

class User {
  let googleUser: GIDGoogleUser
  
  init(googleUser: GIDGoogleUser) {
    self.googleUser = googleUser
  }
}

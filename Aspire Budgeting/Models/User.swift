//
//  User.swift
//  Aspire Budgeting
//
//  Created by TeraMo Labs on 10/20/19.
//  Copyright © 2019 TeraMo Labs. All rights reserved.
//

import Foundation
import GoogleSignIn

class User {
  let googleUser: GIDGoogleUser
  
  init(googleUser: GIDGoogleUser) {
    self.googleUser = googleUser
  }
}

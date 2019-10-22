//
//  User.swift
//  Aspire Budgeting
//
//  Created by TeraMo Labs on 10/20/19.
//  Copyright © 2019 TeraMo Labs. All rights reserved.
//

import Foundation

class User {
  let authToken: String
  
  init(authToken: String) {
    self.authToken = authToken
  }
}

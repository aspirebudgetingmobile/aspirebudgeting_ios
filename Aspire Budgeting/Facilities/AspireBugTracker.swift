//
//  AspireBugTracker.swift
//  Aspire Budgeting
//
//  Created by TeraMo Labs on 3/5/20.
//  Copyright © 2020 TeraMo Labs. All rights reserved.
//

import Foundation
import Instabug

protocol BugTracker {
  static func start(withToken token: String,
                    invocationEvents: IBGInvocationEvent)
}

extension Instabug: BugTracker {}

struct AspireBugTracker {
  let credentials: InstabugCredentials
  
  init(credentials: InstabugCredentials) {
    self.credentials = credentials
  }
  
  func start() {
    Instabug.start(withToken: credentials.beta,
                   invocationEvents: [.shake, .screenshot])
  }
}

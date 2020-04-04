//
//  AspireBugTracker.swift
//  Aspire Budgeting
//
//  Created by TeraMo Labs on 3/5/20.
//  Copyright © 2020 TeraMo Labs. All rights reserved.
//

import Bugsnag
import Foundation

struct AspireBugTracker {
  private let credentials: AspireBugTrackerCredentials
  private let bundle: Bundle
  
  init(credentials: AspireBugTrackerCredentials,
       bundle: Bundle = Bundle.main) {
    self.credentials = credentials
    self.bundle = bundle
  }
  
  func start() {
    let bugTrackerKey = credentials.live
    
    Bugsnag.start(withApiKey: bugTrackerKey)
  }
}

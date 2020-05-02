//
//  AspireBugTracker.swift
//  Aspire Budgeting
//
//  Created by TeraMo Labs on 3/5/20.
//  Copyright © 2020 TeraMo Labs. All rights reserved.
//

import Foundation
import Instabug

struct AspireBugTracker {
  private let credentials: InstabugCredentials
  private let bundle: Bundle

  init(
    credentials: InstabugCredentials,
    bundle: Bundle = Bundle.main
  ) {
    self.credentials = credentials
    self.bundle = bundle
  }

  private func isRunningLive() -> Bool {
    #if targetEnvironment(simulator)
    return false
    #else
    let isRunningTestFlightBeta = (bundle.appStoreReceiptURL?.lastPathComponent == "sandboxReceipt")
    let hasEmbeddedMobileProvision =
      bundle.path(forResource: "embedded", ofType: "mobileprovision") != nil
    if isRunningTestFlightBeta || hasEmbeddedMobileProvision {
      return false
    } else {
      return true
    }
    #endif
  }

  func start() {
    let instabugKey: String
    if isRunningLive() {
      instabugKey = credentials.live
    } else {
      instabugKey = credentials.beta
    }

    Instabug.start(
      withToken: instabugKey,
      invocationEvents: [
        .shake,
        .screenshot,
      ]
    )
  }
}

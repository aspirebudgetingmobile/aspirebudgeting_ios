//
//  LocalAuthorizationManager.swift
//  Aspire Budgeting
//
//  Created by TeraMo Labs on 11/7/19.
//  Copyright © 2019 TeraMo Labs. All rights reserved.
//

import Foundation
import LocalAuthentication
import os.log

extension Notification.Name {
  static let authorizedLocally = Notification.Name("authorizedLocally")
}

final class LocalAuthorizationManager: ObservableObject {
  private var isAuthorized = false

  private var context: LAContext {
    return LAContext()
  }

  func authenticateUserLocally() {
    os_log(
      "Authenticating user locally",
      log: .localAuthorizationManager,
      type: .default
    )
    let context = self.context

    context.localizedCancelTitle = "Cancel"

    var error: NSError?
    if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
      let reason = "Log in to your account"
      context.evaluatePolicy(
        .deviceOwnerAuthentication,
        localizedReason: reason
      ) { [weak self] success, error in
        guard let weakSelf = self else {
          return
        }

        if let error = error {
          os_log(
            "Encountered local authorization error. %{public}s",
            log: .localAuthorizationManager,
            type: .error,
            error.localizedDescription
          )
        }
        os_log(
          "Local Authorization success = %d",
          log: .localAuthorizationManager,
          type: .default,
          success
        )
        weakSelf.isAuthorized = success
        weakSelf.postNotification()
        context.invalidate()
      }
    } else {
      os_log(
        "Cannot evaluate deviceOwnerAuthentication policy",
        log: .localAuthorizationManager,
        type: .error
      )
    }
  }

  private func postNotification() {
    os_log(
      "Local Authorization notification posted",
      log: .localAuthorizationManager,
      type: .default
    )
    let userInfo = [Notification.Name.authorizedLocally: isAuthorized]
    NotificationCenter.default.post(name: .authorizedLocally, object: nil, userInfo: userInfo)
  }
}

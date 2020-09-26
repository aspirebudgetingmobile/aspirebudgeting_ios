//
//  LocalAuthorizationManager.swift
//  Aspire Budgeting
//

import Foundation
import LocalAuthentication
import os.log

protocol AppLocalAuthorizer {
  func authenticateUserLocally(completion: @escaping (Bool) -> Void)
}

#warning("Remove extension below")
extension Notification.Name {
  static let authorizedLocally = Notification.Name("authorizedLocally")
}

final class LocalAuthorizationManager: AppLocalAuthorizer {

  private var context: LAContext {
    LAContext()
  }

  func authenticateUserLocally(completion: @escaping (Bool) -> Void) {
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
      ) { success, error in
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
        completion(success)
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
}

//
//  LocalAuthorizationManager.swift
//  Aspire Budgeting
//

import Foundation
import LocalAuthentication

protocol AppLocalAuthorizer {
  func authenticateUserLocally(completion: @escaping (Bool) -> Void)
}

final class LocalAuthorizationManager: AppLocalAuthorizer {

  private var context: LAContext {
    LAContext()
  }

  func authenticateUserLocally(completion: @escaping (Bool) -> Void) {
    Logger.info(
      "Authenticating user locally"
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
          Logger.error(
            "Encountered local authorization error.",
            context: error.localizedDescription
          )
        }
        Logger.info(
          "Local Authorization success = ",
          context: success
        )
        completion(success)
        context.invalidate()
      }
    } else {
      Logger.error(
        "Cannot evaluate deviceOwnerAuthentication policy"
      )
    }
  }
}

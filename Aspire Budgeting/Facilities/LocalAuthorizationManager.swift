//
//  LocalAuthorizationManager.swift
//  Aspire Budgeting
//

import Combine
import Foundation
import LocalAuthentication

protocol AppLocalAuthorizer {
  func authenticateUserLocally() -> AnyPublisher<Void, Error>
}

final class LocalAuthorizationManager: AppLocalAuthorizer {

  /// Creates a new context. Required as the previous context could be invalidated.
  private var context: LAContext {
    LAContext()
  }

  func authenticateUserLocally() -> AnyPublisher<Void, Error> {
    Deferred {
      Future { [weak self] promise in
        guard let self = self else { return }
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
              promise(.failure(error))
            }
            Logger.info(
              "Local Authorization success = ",
              context: success
            )
            promise(.success(()))
            context.invalidate()
          }
        } else {
          Logger.error(
            "Cannot evaluate deviceOwnerAuthentication policy"
          )
        }

      }
    }.eraseToAnyPublisher()
  }
}

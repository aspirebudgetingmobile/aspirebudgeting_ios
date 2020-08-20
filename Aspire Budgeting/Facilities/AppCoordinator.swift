//
// AppCoordinator.swift
// Aspire Budgeting
//

import Foundation
import Combine

final class AppCoordinator: ObservableObject {
  private let stateManager: AppStateManager
  private let localAuthorizer: AppLocalAuthorizer

  private var stateManagerSink: AnyCancellable!

  init(stateManager: AppStateManager,
       localAuthorizer: AppLocalAuthorizer) {
    self.stateManager = stateManager
    self.localAuthorizer = localAuthorizer
  }

  func start() {
    stateManagerSink = stateManager
      .currentState
      .receive(on: DispatchQueue.main)
      .sink {
        self.objectWillChange.send()
        self.handle(state: $0)
      }
  }

  func pause() {
    self.stateManager.pause()
  }

  func resume() {
    if needsLocalAuth {
      self.localAuthorizer.authenticateUserLocally {
        self.stateManager.authenticatedLocally(result: $0)
      }
    }
  }
}

// MARK: -  State Management
extension AppCoordinator {
  func handle(state: AppState) {
    switch state {
    case .verifiedExternally:
      self.localAuthorizer
        .authenticateUserLocally {
          self.stateManager.authenticatedLocally(result: $0)
        }

    default:
      print("The current state is \(state)")
    }
  }
}

// MARK: - Computed Properties
extension AppCoordinator {
  var needsLocalAuth: Bool {
    stateManager.needsLocalAuth
  }

  var isLoggedOut: Bool {
    stateManager.isLoggedOut
  }

  var hasDefaultSheet: Bool {
    stateManager.hasDefaultSheet
  }
}

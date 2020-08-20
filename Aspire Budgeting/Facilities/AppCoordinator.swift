//
// AppCoordinator.swift
// Aspire Budgeting
//

import Foundation
import Combine

final class AppCoordinator: ObservableObject {
  private let stateManager: AppStateManager
  private let localAuthorizer: AppLocalAuthorizer
  private let appDefaults: AppDefaults

  private var stateManagerSink: AnyCancellable!

  init(stateManager: AppStateManager,
       localAuthorizer: AppLocalAuthorizer,
       appDefaults: AppDefaults) {
    self.stateManager = stateManager
    self.localAuthorizer = localAuthorizer
    self.appDefaults = appDefaults
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
    self.stateManager.processEvent(event: .enteredBackground)
  }

  func resume() {
    if needsLocalAuth {
      self.localAuthorizer.authenticateUserLocally {
        self.stateManager.processEvent(event: .authenticatedLocally(result: $0))
      }
    }
  }
}

// MARK: - State Management
extension AppCoordinator {
  func handle(state: AppState) {
    switch state {
    case .verifiedExternally:
      self.localAuthorizer
        .authenticateUserLocally {
          self.stateManager.processEvent(event: .authenticatedLocally(result: $0))
        }

    case .authenticatedLocally:
      guard let file = self.appDefaults.getDefaultFile() else {
        return
      }
      self.stateManager.processEvent(event: .hasDefaultFile)
      //TODO: pass the file to sheets manager

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

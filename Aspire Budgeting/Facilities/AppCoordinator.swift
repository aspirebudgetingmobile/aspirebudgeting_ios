//
// AppCoordinator.swift
// Aspire Budgeting
//

import Foundation
import Combine

final class AppCoordinator: ObservableObject {
  private let stateManager: AppStateManager

  private var stateManagerSink: AnyCancellable!

  init(stateManager: AppStateManager) {
    self.stateManager = stateManager
  }

  func start() {
    stateManagerSink = stateManager
      .currentState
      .sink { _ in self.objectWillChange.send() }
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

//
// AppCoordinator.swift
// Aspire Budgeting
//

import Foundation
import Combine

class AppCoordinator: ObservableObject {
  private let stateManager: AppStateManager

//  @Published private(set) var appState: AppState = .loggedOut
//  var appState = CurrentValueSubject<AppState, Never>(.loggedOut)
//  private(set) var __appState: AppState = .lo

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
    stateManager.currentState.value == .verifiedGoogleUser
      || stateManager.currentState.value == .localAuthFailed
      || stateManager.currentState.value == .needsLocalAuthentication
  }

  var isLoggedOut: Bool {
    stateManager.currentState.value == .loggedOut
  }

  var hasDefaultSheet: Bool {
    stateManager.currentState.value == .hasDefaultSheet
  }
}

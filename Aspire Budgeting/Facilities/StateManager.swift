//
//  StateManager.swift
//  Aspire Budgeting
//

import Combine
import Foundation
import os.log

enum AppState: Equatable {
  case loggedOut
  case verifiedExternally
  case authenticatedLocally
  case localAuthFailed
  case needsLocalAuthentication
  case hasDefaultSheet
}

protocol AppStateManager {
  var currentState: CurrentValueSubject<AppState, Never> { get }

  var needsLocalAuth: Bool { get }
  var isLoggedOut: Bool { get }
  var hasDefaultSheet: Bool { get }

  func authenticatedLocally(result: Bool)
  func pause()
}

final class StateManager: AppStateManager {
  private(set) var currentState = CurrentValueSubject<AppState, Never>(.loggedOut)

  private var authorizerObserver: NSObjectProtocol?
  private var backgroundObserver: NSObjectProtocol?
  private var defaultSheetObserver: NSObjectProtocol?
  private var logoutObserver: NSObjectProtocol?

  private lazy var transitions: [AppState: Set<AppState>] = {
    var transitions = [AppState: Set<AppState>]()

    transitions[.loggedOut] = [.verifiedExternally]
    transitions[.verifiedExternally] = [.authenticatedLocally, .localAuthFailed]
    transitions[.authenticatedLocally] = [
      .localAuthFailed,
      .hasDefaultSheet,
      .needsLocalAuthentication,
      .loggedOut,
    ]
    transitions[.hasDefaultSheet] = [.needsLocalAuthentication, .loggedOut]
    transitions[.needsLocalAuthentication] = [.authenticatedLocally, .localAuthFailed]
    transitions[.localAuthFailed] = [.authenticatedLocally]

    return transitions
  }()

  init() {
    authorizerObserver =
      NotificationCenter.default.addObserver(
        forName: .authorizerUpdated,
        object: nil,
        queue: nil
      ) { _ in
        os_log(
          "Authorizer updated. Transitioning to verifiedGoogleUser",
          log: .stateManager,
          type: .default
        )
        self.transition(to: .verifiedExternally)
      }

    defaultSheetObserver = NotificationCenter.default.addObserver(
      forName: .hasSheetInDefaults,
      object: nil,
      queue: nil
    ) { _ in
      os_log(
        "Received hasSheetInDefaults. Transitioning to hasDefaultSheet",
        log: .stateManager,
        type: .default
      )
      self.transition(to: .hasDefaultSheet)
    }

    logoutObserver = NotificationCenter.default.addObserver(
      forName: .logout,
      object: nil,
      queue: nil
    ) { _ in
      os_log(
        "Received logout. Transitioning to logout",
        log: .stateManager,
        type: .default
      )
      self.transition(to: .loggedOut)
    }
  }

  func transition(to nextState: AppState) {
    if canTransition(to: nextState) {
      currentState.value = nextState
    } else {
      os_log(
        "Invalid state transition. No state transition performed.",
        log: .stateManager,
        type: .error
      )
    }
  }

  func canTransition(to nextState: AppState) -> Bool {
    guard let validTransitions = transitions[currentState.value] else {
      return false
    }

    return validTransitions.contains(nextState)
  }
}

// MARK: - Computed Properties
extension StateManager {
  var needsLocalAuth: Bool {
    let currentValue = currentState.value
    return currentValue == .verifiedExternally
      || currentValue == .localAuthFailed
      || currentValue == .needsLocalAuthentication
  }

  var isLoggedOut: Bool {
    let currentValue = currentState.value
    return currentValue == .loggedOut
  }

  var hasDefaultSheet: Bool {
    let currentValue = currentState.value
    return currentValue == .hasDefaultSheet
  }
}

//MARK: - AppStateManager Protocol Methods
extension StateManager {
  func authenticatedLocally(result: Bool) {
    if result {
      os_log(
        "Transitioning to authenticatedLocally",
        log: .stateManager,
        type: .default
      )
      self.transition(to: .authenticatedLocally)
    } else {
      os_log(
        "Transitioning to localAuthFailed",
        log: .stateManager,
        type: .error
      )
      self.transition(to: .localAuthFailed)
    }
  }

  func pause() {
    self.transition(to: .needsLocalAuthentication)
  }
}

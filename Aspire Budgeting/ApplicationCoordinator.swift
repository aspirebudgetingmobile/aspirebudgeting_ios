//
// ApplicationCoordinator.swift
// Aspire Budgeting
//

import Foundation

protocol ApplicationStateTransitioning {
  func transition(to applicationState: ApplicationState)
}

/// An enumeration of the various states of the application.
enum ApplicationState {
  /// The application is launching from a killed stated.
  case launching
  /// The application has launched and is in the foreground.
  case launched
  /// The user needs to sign in.
  case signIn
  /// The user is signed in but needs to authenticate with biometrics.
  case authentication
  /// The is signed in and authenticated and is able to access the main content.
  case main
}

/// To manage transitions between `ApplicationStates`.
final class ApplicationCoordinator {

  private var applicationState: ApplicationState = .launching

  private let applicationStateTransitioning: ApplicationStateTransitioning

  init(applicationStateTransitioning: ApplicationStateTransitioning) {
    self.applicationStateTransitioning = applicationStateTransitioning
  }

  // MARK: - API
  func applicationDidEnterBackground() {

  }

  func applicationDidEnterForeground() {

  }

  // TODO: This will move out of here
  private func configureDependencies() {

  }
}

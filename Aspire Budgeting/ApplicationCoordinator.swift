//
// ApplicationCoordinator.swift
// Aspire Budgeting
//

import Foundation

protocol ApplicationStateTransitioning {
//  func transition(to applicationState: ApplicationState)
}

/// An enumeration of the various states of the application.
enum ApplicationState {
  /// The application is launching from a killed stated.
  case launching
  /// The application has launched and is in the foreground.
  case launched
  /// The user needs to sign in.
  case requiresSignIn
  /// The user is signed in but needs to authenticate.
  case requiresAuthentication
  /// The is signed in and authenticated and is able to access the main content.
  case main
}

/// To manage transitions between `ApplicationStates`.
final class ApplicationCoordinator {
  private var applicationState: ApplicationState = .launching {
    didSet {
      applicationStateObservable.updateApplicationState(to: applicationState)
    }
  }

  private let applicationStateObservable: ApplicationStateObservable
  let rootView: ApplicationRootView

  init() {
    applicationStateObservable = ApplicationStateObservable(applicationState: applicationState)
    rootView = ApplicationRootView(applicationStateObservable: applicationStateObservable)
  }

  // MARK: - API

  func activate() {
    // configure the dependencies here for now...
    applicationState = .launched
    DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
      self.applicationState = .requiresSignIn
    }
  }

  /// Sets the application state to require authentication
  func applicationDidEnterBackground() {
    applicationState = .requiresAuthentication
  }

  func applicationDidEnterForeground() {}

  // TODO: This will move out of here
  private func configureDependencies() {}
}

/// A wrapper to wrap the `ApplicationState` that can be observed. This is a workround because
/// we do not want the view to hold onto the `ApplicationCordinator` but be notified of chanages to
/// the `applicationState` property.
final class ApplicationStateObservable: ObservableObject {
  @Published private(set) var applicationState: ApplicationState

  init(applicationState: ApplicationState) {
    self.applicationState = applicationState
  }

  func updateApplicationState(to applicationState: ApplicationState) {
    self.applicationState = applicationState
  }
}

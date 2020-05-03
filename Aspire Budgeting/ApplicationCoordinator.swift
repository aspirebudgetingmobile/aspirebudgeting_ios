//
// ApplicationCoordinator.swift
// Aspire Budgeting
//

import Foundation

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
  let applicationRootView: ApplicationRootView

  init() {
    applicationStateObservable = ApplicationStateObservable(applicationState: applicationState)
    applicationRootView = ApplicationRootView(
      applicationStateObservable: applicationStateObservable
    )
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

  // MARK: - Private

  private func signInOrAuthenticate() {

  }
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


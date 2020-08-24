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
  private let remoteFileManager: RemoteFileManager
  private let userManager: UserManager

  private var stateManagerSink: AnyCancellable!
  private var remoteFileManagerSink: AnyCancellable!

  private(set) var fileSelectorVM = FileSelectorViewModel()

  init(stateManager: AppStateManager,
       localAuthorizer: AppLocalAuthorizer,
       appDefaults: AppDefaults,
       remoteFileManager: RemoteFileManager,
       userManager: UserManager) {
    self.stateManager = stateManager
    self.localAuthorizer = localAuthorizer
    self.appDefaults = appDefaults
    self.remoteFileManager = remoteFileManager
    self.userManager = userManager
  }

  func start() {
    stateManagerSink = stateManager
      .currentState
      .receive(on: DispatchQueue.main)
      .sink {
        self.objectWillChange.send()
        self.handle(state: $0)
      }

    remoteFileManagerSink = remoteFileManager
      .currentState
      .sink {
        self.fileSelectorVM =
          FileSelectorViewModel(fileManagerState: $0,
                                fileSelectedCallback: self.fileSelectedCallBack)
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

// MARK: - Callbacks
extension AppCoordinator {
  func fileSelectedCallBack(file: File) {
    print("Logic to verify file \(file)")
  }
}
// MARK: - State Management
extension AppCoordinator {
  func handle(state: AppState) {
    switch state {
    case .loggedOut:
      userManager.authenticateWithService()

    case .verifiedExternally:
      self.localAuthorizer
        .authenticateUserLocally {
          self.stateManager.processEvent(event: .authenticatedLocally(result: $0))
        }

    case .authenticatedLocally:
      guard let file = self.appDefaults.getDefaultFile() else {
        remoteFileManager.getFileList()
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

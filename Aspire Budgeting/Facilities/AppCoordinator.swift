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
  private let fileValidator: FileValidator
  private let contentProvider: ContentProvider

  private var stateManagerSink: AnyCancellable!
  private var remoteFileManagerSink: AnyCancellable!
  private var userManagerSink: AnyCancellable!
  private var fileValidatorSink: AnyCancellable!

  private(set) var fileSelectorVM = FileSelectorViewModel()
  private(set) var dashboardVM = DashboardViewModel()

  private var user: User?

  /// Only set when a file is selected from the FileSelectorView
  private var selectedFile: File?
  private var dataMap: [String: String]?

  init(stateManager: AppStateManager,
       localAuthorizer: AppLocalAuthorizer,
       appDefaults: AppDefaults,
       remoteFileManager: RemoteFileManager,
       userManager: UserManager,
       fileValidator: FileValidator,
       contentProvider: ContentProvider) {
    self.stateManager = stateManager
    self.localAuthorizer = localAuthorizer
    self.appDefaults = appDefaults
    self.remoteFileManager = remoteFileManager
    self.userManager = userManager
    self.fileValidator = fileValidator
    self.contentProvider = contentProvider
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
        self.objectWillChange.send()
      }

    userManagerSink = userManager.currentState.sink {
      switch $0 {
      case .authenticated(let user):
        self.user = user
        self.stateManager.processEvent(event: .verifiedExternally)
      default:
        self.user = nil
      }
    }

    fileValidatorSink = fileValidator.currentState.sink {
      switch $0 {
      case .isLoading:
        self.remoteFileManager.currentState.value = .isLoading

      case .dataMapRetrieved(let dataMap):
        guard let file = self.selectedFile else {
          fatalError("Selected file is nil. This should never happen.")
        }
        self.dataMap = dataMap
        self.appDefaults.addDefault(file: file)
        self.appDefaults.addDataMap(map: dataMap)
        self.stateManager.processEvent(event: .hasDefaultFile)
        self.contentProvider.getDashboard(for: self.user!,
                                          from: self.selectedFile!,
                                          using: self.dataMap!)
        {
          self.dashboardVM = DashboardViewModel(result: $0)
          self.objectWillChange.send()
        }

      case .error(let error):
        self.remoteFileManager.currentState.value = .error(error: error)
      }
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
    self.selectedFile = file
    fileValidator.validate(file: file, for: self.user!)
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
        remoteFileManager.getFileList(for: self.user!)
        return
      }
      self.stateManager.processEvent(event: .hasDefaultFile)
      self.contentProvider.getDashboard(for: self.user!,
                                        from: file,
                                        using: self.appDefaults.getDataMap()) {
        self.dashboardVM =
          DashboardViewModel(result: $0)
                                          self.objectWillChange.send()
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

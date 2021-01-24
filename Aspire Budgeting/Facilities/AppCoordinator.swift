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
  private(set) lazy var dashboardVM: DashboardViewModel = {
    DashboardViewModel(refreshAction: self.dashboardRefreshCallback)
  }()
  private(set) lazy var accountBalancesVM: AccountBalancesViewModel = {
    AccountBalancesViewModel(refreshAction: self.accountBalancesRefreshCallback)
  }()
  private(set) lazy var addTransactionVM: AddTransactionViewModel = {
    AddTransactionViewModel(refreshAction: self.addTransactionRefreshCallback)
  }()

  private var user: User?

  private var selectedFile: File?
  private var dataLocationMap: [String: String]?

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
        self.dataLocationMap = dataMap
        self.appDefaults.addDefault(file: file)
        self.appDefaults.addDataLocationMap(map: dataMap)
        self.stateManager.processEvent(event: .hasDefaultFile)
        self.selectedFile = file

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

  func dashboardRefreshCallback() {
    self.contentProvider
      .getData(for: self.user!,
               from: self.selectedFile!,
               using: self.dataLocationMap!) { (readResult: Result<Dashboard>) in

        let result: Result<DashboardDataProvider>

        switch readResult {
        case .success(let dashboard):
          result = .success(DashboardDataProvider(dashboard: dashboard))

        case .failure(let error):
          result = .failure(error)
        }

        self.dashboardVM =
          DashboardViewModel(result: result,
                             refreshAction: self.dashboardRefreshCallback)
        self.objectWillChange.send()
      }
  }

  func accountBalancesRefreshCallback() {
    self.contentProvider
      .getData(for: self.user!,
               from: self.selectedFile!,
               using: self.dataLocationMap!) { (readResult: Result<AccountBalances>) in

        let result: Result<AccountBalancesDataProvider>

        switch readResult {
        case .success(let accountBalance):
          result = .success(AccountBalancesDataProvider(accountBalances: accountBalance))

        case .failure(let error):
          result = .failure(error)
        }

        self.accountBalancesVM =
          AccountBalancesViewModel(result: result,
                                   refreshAction:
                                    self.accountBalancesRefreshCallback)
        self.objectWillChange.send()
      }
  }

  func addTransactionRefreshCallback() {
    self.contentProvider
      .getBatchData(for: self.user!,
                    from: self.selectedFile!,
                    using: self.dataLocationMap!) { (readResult: Result<AddTransactionMetadata>) in

        let result: Result<AddTrxDataProvider>

        switch readResult {
        case .success(let metadata):
          result = .success(AddTrxDataProvider(metadata: metadata, submitAction: self.submit))

        case .failure(let error):
          result = .failure(error)
        }

        self.addTransactionVM =
          AddTransactionViewModel(result: result,
                                  refreshAction: self.addTransactionRefreshCallback)
        self.objectWillChange.send()
      }
  }

  func submit(transaction: Transaction, callback: @escaping SubmitResultHandler) {
    self.contentProvider
      .write(data: transaction,
             for: self.user!,
             to: self.selectedFile!,
             using: self.dataLocationMap!) { result in
        callback(result)
      }
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
      self.selectedFile = file
      self.dataLocationMap = self.appDefaults.getDataLocationMap()

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

//
// AppCoordinator.swift
// Aspire Budgeting
//

import Foundation
import Combine

typealias SelectedFilePublisher = PassthroughSubject<File, Never>

final class AppCoordinator: ObservableObject {
  private let stateManager: AppStateManager
  private let localAuthorizer: AppLocalAuthorizer
  private let appDefaults: AppDefaults
  private let remoteFileManager: RemoteFileManager
  private let userManager: UserManager
  private let fileValidator: FileValidator
  private let contentProvider: ContentProvider

  private let selectedFilePublisher = SelectedFilePublisher()

  private var cancellables = Set<AnyCancellable>()

  let fileSelectorVM: FileSelectorViewModel

  private(set) lazy var dashboardVM: DashboardViewModel = {
    DashboardViewModel(refreshAction: self.dashboardRefreshCallback)
  }()
  private(set) lazy var accountBalancesVM: AccountBalancesViewModel = {
    AccountBalancesViewModel(refreshAction: self.accountBalancesRefreshCallback)
  }()
  private(set) lazy var addTransactionVM: AddTransactionViewModel = {
    AddTransactionViewModel(refreshAction: self.addTransactionRefreshCallback)
  }()
  private(set) lazy var transactionsVM: TransactionsViewModel = {
    TransactionsViewModel(refreshAction:
                            self.transactionsRefreshCallback)
  }()
  private(set) lazy var settingsVM: SettingsViewModel = {
    SettingsViewModel(fileName: selectedFile!.name, changeSheet: self.changeSheet, fileSelectorVM: self.fileSelectorVM)
  }()

  @Published private(set) var user: User?

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

    self.fileSelectorVM =
      FileSelectorViewModel(
        fileManager: remoteFileManager,
        userPublisher: userManager.userPublisher,
        fileSelectedPublisher: selectedFilePublisher
      )
  }

  func start() {
    stateManager
      .currentState
      .receive(on: DispatchQueue.main)
      .sink {
        self.objectWillChange.send()
        self.handle(state: $0)
      }
      .store(in: &cancellables)

//    remoteFileManager
//      .currentState
//      .sink {
//        self.fileSelectorVM =
//          FileSelectorViewModel(fileManagerState: $0,
//                                fileSelectedCallback: self.fileSelectedCallBack)
//        self.objectWillChange.send()
//      }
//      .store(in: &cancellables)

    userManager
      .userPublisher
      .receive(on: DispatchQueue.main)
      .sink { completion in
        switch completion {
        case let .failure(error):
          Logger.info("App Start publisher sequence failed")
        case .finished:
          Logger.info("App started successfully")
        }
      } receiveValue: { result in
        switch result {
        case let .success(user):
          self.user = user
        default:
          break
        }
      }
      .store(in: &cancellables)

    selectedFilePublisher
      .zip(userManager.userPublisher)
      .tryMap { (file, userResult) -> (File, User) in
        switch userResult {
        case let .success(user):
          return (file, user)
        case let .failure(error):
          throw error
        }
      }
      .sink { completion in
        print(completion)
      } receiveValue: { (file, user) in
        self.fileValidator.validate(file: file, for: user)
      }
      .store(in: &cancellables)



    userManager.authenticate()


    fileValidator.currentState.sink {
      switch $0 {
      case .isLoading:
//        self.remoteFileManager.currentState.value = .isLoading
      break

      case .dataMapRetrieved(let dataMap):
        guard let file = self.selectedFile else {
          fatalError("Selected file is nil. This should never happen.")
        }
        self.dataLocationMap = dataMap
        self.appDefaults.addDefault(file: file)
        self.appDefaults.addDataLocationMap(map: dataMap)
        self.stateManager.processEvent(event: .hasDefaultFile)
        self.selectedFile = file
        self.settingsVM = SettingsViewModel(
          fileName: file.name,
          changeSheet: self.changeSheet,
          fileSelectorVM: self.fileSelectorVM)
      case .error(let error):
//        self.remoteFileManager.currentState.value = .error(error: error)
      break
      }
    }
    .store(in: &cancellables)
  }

  func pause() {
    self.stateManager.processEvent(event: .enteredBackground)
  }

  func resume() {
    if needsLocalAuth {
//      self.localAuthorizer.authenticateUserLocally {
//        self.stateManager.processEvent(event: .authenticatedLocally(result: $0))
//      }
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

  func transactionsRefreshCallback() {
    self.contentProvider
      .getData(for: self.user!,
               from: self.selectedFile!,
               using: self.dataLocationMap!) { (readResult: Result<Transactions>) in

        let result: Result<TransactionsDataProvider>

        switch readResult {
        case .success(let transactions):
          result = .success(TransactionsDataProvider(transactions: transactions))

        case .failure(let error):
          result = .failure(error)
        }

        self.transactionsVM =
          TransactionsViewModel(result: result,
                                refreshAction: self.transactionsRefreshCallback)
        self.objectWillChange.send()
      }
  }

  func submit(transaction: Transaction, resultHandler: @escaping SubmitResultHandler) {
    self.contentProvider
      .write(data: transaction,
             for: self.user!,
             to: self.selectedFile!,
             using: self.dataLocationMap!) { result in
        resultHandler(result)
      }
  }

  func changeSheet() {
    self.appDefaults.clearDefaultFile()
    handle(state: .changeSheet)
//    self.fileSelectorVM = FileSelectorViewModel()
    self.dashboardVM = DashboardViewModel(refreshAction: self.dashboardRefreshCallback)
    self.accountBalancesVM = AccountBalancesViewModel(refreshAction: self.accountBalancesRefreshCallback)
    self.addTransactionVM = AddTransactionViewModel(refreshAction: self.addTransactionRefreshCallback)
    self.transactionsVM = TransactionsViewModel(refreshAction:
                                                      self.transactionsRefreshCallback)
    handle(state: .authenticatedLocally)
    Logger.info("Sheet changed")
    self.objectWillChange.send()
  }
}

// MARK: - State Management
extension AppCoordinator {
  func handle(state: AppState) {
    switch state {
    case .loggedOut:
//      userManager.authenticate()
    break

    case .verifiedExternally:
//      self.localAuthorizer
//        .authenticateUserLocally {
//          self.stateManager.processEvent(event: .authenticatedLocally(result: $0))
//        }
    break

    case .authenticatedLocally:
      guard let file = self.appDefaults.getDefaultFile() else {
//        remoteFileManager.getFileList(for: self.user!)
        return
      }
      self.stateManager.processEvent(event: .hasDefaultFile)
      self.selectedFile = file
      self.dataLocationMap = self.appDefaults.getDataLocationMap()

    case .changeSheet:
      self.stateManager.processEvent(event: .changeSheet)

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
    user == nil
  }

  var hasDefaultSheet: Bool {
    stateManager.hasDefaultSheet
  }
}

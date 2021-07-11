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

  private var cancellables = Set<AnyCancellable>()

  private(set) var fileSelectorVM: FileSelectorViewModel!

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

//  private(set) lazy var settingsVM: SettingsViewModel = {
//    SettingsViewModel(fileName: selectedFile!.name,
//  changeSheet: self.changeSheet, fileSelectorVM: self.fileSelectorVM)
//  }()

  @Published private(set) var user: User?
  @Published private(set) var selectedSheet: AspireSheet?
  // TODO: Remove these two
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

  func start(for user: User) {
    self.user = user
    self.selectedSheet = appDefaults.getDefaultSheet()

    fileSelectorVM = FileSelectorViewModel(
      fileManager: remoteFileManager,
      fileValidator: fileValidator,
      user: user
    )

    fileSelectorVM
      .$aspireSheet
      .compactMap { $0 }
      .sink { aspireSheet in
        self.selectedSheet = aspireSheet
        self.appDefaults.addDefault(sheet: aspireSheet)
      }
      .store(in: &cancellables)

    // TODO: Remove
    stateManager
      .currentState
      .receive(on: DispatchQueue.main)
      .sink {
        self.objectWillChange.send()
        self.handle(state: $0)
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
  func dashboardRefreshCallback() {
    self.contentProvider
      .getData(for: self.user!,
               from: self.selectedSheet!.file,
               using: self.selectedSheet!.dataMap)
      .sink { completion in
        print(completion)
      } receiveValue: { (dashboard: Dashboard) in
        print(dashboard)
      }
      .store(in: &cancellables)

//    self.contentProvider
//      .getData(for: self.user!,
//               from: self.selectedSheet!.file,
//               using: self.selectedSheet!.dataMap) { (readResult: Result<Dashboard>) in
//
//        let result: Result<DashboardDataProvider>
//
//        switch readResult {
//        case .success(let dashboard):
//          result = .success(DashboardDataProvider(dashboard: dashboard))
//
//        case .failure(let error):
//          result = .failure(error)
//        }
//
//        self.dashboardVM =
//          DashboardViewModel(result: result,
//                             refreshAction: self.dashboardRefreshCallback)
//        self.objectWillChange.send()
//      }
  }

  func accountBalancesRefreshCallback() {
//    self.contentProvider
//      .getData(for: self.user!,
//               from: self.selectedSheet!.file,
//               using: self.selectedSheet!.dataMap) { (readResult: Result<AccountBalances>) in
//
//        let result: Result<AccountBalancesDataProvider>
//
//        switch readResult {
//        case .success(let accountBalance):
//          result = .success(AccountBalancesDataProvider(accountBalances: accountBalance))
//
//        case .failure(let error):
//          result = .failure(error)
//        }
//
//        self.accountBalancesVM =
//          AccountBalancesViewModel(result: result,
//                                   refreshAction:
//                                    self.accountBalancesRefreshCallback)
//        self.objectWillChange.send()
//      }
  }

  func addTransactionRefreshCallback() {
    self.contentProvider
      .getBatchData(for: self.user!,
                    from: self.selectedSheet!.file,
                    using: self.selectedSheet!.dataMap) { (readResult: Result<AddTransactionMetadata>) in

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
//    self.contentProvider
//      .getData(for: self.user!,
//               from: self.selectedSheet!.file,
//               using: self.selectedSheet!.dataMap) { (readResult: Result<Transactions>) in
//
//        let result: Result<TransactionsDataProvider>
//
//        switch readResult {
//        case .success(let transactions):
//          result = .success(TransactionsDataProvider(transactions: transactions))
//
//        case .failure(let error):
//          result = .failure(error)
//        }
//
//        self.transactionsVM =
//          TransactionsViewModel(result: result,
//                                refreshAction: self.transactionsRefreshCallback)
//        self.objectWillChange.send()
//      }
  }

  func submit(transaction: Transaction, resultHandler: @escaping SubmitResultHandler) {
    self.contentProvider
      .write(data: transaction,
             for: self.user!,
             to: self.selectedSheet!.file,
             using: self.selectedSheet!.dataMap) { result in
        resultHandler(result)
      }
  }

  func changeSheet() {
    self.appDefaults.clearDefaultFile()
    handle(state: .changeSheet)
//    self.fileSelectorVM = FileSelectorViewModel()
    self.dashboardVM = DashboardViewModel(refreshAction: self.dashboardRefreshCallback)
    self.accountBalancesVM =
      AccountBalancesViewModel(refreshAction: self.accountBalancesRefreshCallback)
    self.addTransactionVM =
      AddTransactionViewModel(refreshAction: self.addTransactionRefreshCallback)
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
      guard let sheet = self.appDefaults.getDefaultSheet() else {
//        remoteFileManager.getFileList(for: self.user!)
        return
      }
      self.stateManager.processEvent(event: .hasDefaultFile)
      self.selectedFile = sheet.file
      self.dataLocationMap = sheet.dataMap

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
    selectedSheet != nil
  }
}

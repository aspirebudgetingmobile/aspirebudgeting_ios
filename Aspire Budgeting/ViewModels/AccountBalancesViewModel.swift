//
// AccountBalancesViewModel.swift
// Aspire Budgeting
//

import Foundation

struct AccountBalancesViewModel {
  let currentState: ViewModelState
  let accountBalances: AccountBalances?
  let error: Error?

  private let refreshAction: (() -> Void)

  init(result: Result<AccountBalances>?,
       refreshAction: @escaping (() -> Void)) {

    self.refreshAction = refreshAction

    if let result = result {
      switch result {
      case .failure(let error):
        self.error = error
        self.accountBalances = nil
        self.currentState = .error

      case .success(let dashboard):
        self.accountBalances = dashboard
        self.error = nil
        self.currentState = .dataRetrieved
      }
    } else {
      self.accountBalances = nil
      self.error = nil
      self.currentState = .isLoading
    }
  }

  init(refreshAction: @escaping () -> Void) {
    self.init(result: nil, refreshAction: refreshAction)
  }

  func refresh() {
    refreshAction()
  }
}

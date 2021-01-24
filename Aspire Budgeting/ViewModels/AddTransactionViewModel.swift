//
// AddTransactionViewModel.swift
// Aspire Budgeting
//

import Foundation

typealias AddTransactionViewModel = ViewModel<AddTrxDataProvider>

class AddTrxDataProvider: ObservableObject {
  let transactionCategories: [String]
  let transactionAccounts: [String]
  let submit: (Transaction, @escaping (Result<Any>) -> Void) -> Void

  @Published var result: Result<Any>?

  init(metadata: AddTransactionMetadata,
       submitAction: @escaping (Transaction, @escaping (Result<Any>) -> Void) -> Void) {
    self.transactionCategories = metadata.transactionCategories
    self.transactionAccounts = metadata.transactionAccounts
    self.submit = submitAction
  }
}

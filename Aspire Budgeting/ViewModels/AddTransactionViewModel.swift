//
// AddTransactionViewModel.swift
// Aspire Budgeting
//

import Foundation

typealias AddTransactionViewModel = ViewModel<AddTrxDataProvider>

struct AddTrxDataProvider {
  let transactionCategories: [String]
  let transactionAccounts: [String]
  let submit: (Transaction, @escaping (Result<Any>) -> Void) -> Void

  init(metadata: AddTransactionMetadata,
       submitAction: @escaping (Transaction, @escaping (Result<Any>) -> Void) -> Void) {
    self.transactionCategories = metadata.transactionCategories
    self.transactionAccounts = metadata.transactionAccounts
    self.submit = submitAction
  }
}

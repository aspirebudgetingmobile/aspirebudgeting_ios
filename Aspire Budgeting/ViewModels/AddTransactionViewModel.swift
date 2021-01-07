//
// AddTransactionViewModel.swift
// Aspire Budgeting
//

import Foundation

typealias AddTransactionViewModel = ViewModel<AddTrxDataProvider>

struct AddTrxDataProvider {
  let transactionCategories: [String]
  let transactionAccounts: [String]
  let submit: (Transaction) -> Void

  init(metadata: AddTransactionMetadata,
       submitAction: @escaping (Transaction) -> Void) {
    self.transactionCategories = metadata.transactionCategories
    self.transactionAccounts = metadata.transactionAccounts
    self.submit = submitAction
  }
}

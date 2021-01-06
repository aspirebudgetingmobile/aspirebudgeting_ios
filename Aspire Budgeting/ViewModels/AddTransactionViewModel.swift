//
// AddTransactionViewModel.swift
// Aspire Budgeting
//

import Foundation

typealias AddTransactionViewModel = ViewModel<AddTrxDataProvider>

struct AddTrxDataProvider {
  let transactionCategories: [String]
  let transactionAccounts: [String]

  init(metadata: AddTransactionMetadata) {
    self.transactionCategories = metadata.transactionCategories
    self.transactionAccounts = metadata.transactionAccounts
  }
}

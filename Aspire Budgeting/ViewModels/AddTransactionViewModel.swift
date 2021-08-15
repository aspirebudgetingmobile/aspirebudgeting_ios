//
// AddTransactionViewModel.swift
// Aspire Budgeting
//

import Foundation

typealias AddTransactionViewModel = ViewModel<AddTrxDataProvider>
typealias SubmitResultHandler = (Result<Void>) -> Void
struct AddTrxDataProvider {
  let transactionCategories: [String]
  let transactionAccounts: [String]
  let submit: (Transaction, @escaping SubmitResultHandler) -> Void

  init(metadata: AddTransactionMetadata,
       submitAction: @escaping (Transaction, @escaping SubmitResultHandler) -> Void) {
    self.transactionCategories = metadata.transactionCategories
    self.transactionAccounts = metadata.transactionAccounts
    self.submit = submitAction
  }
}

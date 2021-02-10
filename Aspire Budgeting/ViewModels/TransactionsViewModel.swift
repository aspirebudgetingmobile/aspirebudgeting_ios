//
// TransactionsViewModel.swift
// Aspire Budgeting
//

import Foundation
typealias TransactionsViewModel = ViewModel<TransactionsDataProvider>

struct TransactionsDataProvider {
  let transactions: Transactions
}

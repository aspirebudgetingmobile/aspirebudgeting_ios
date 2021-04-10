//
// TransactionsViewModel.swift
// Aspire Budgeting
//

import Foundation
typealias TransactionsViewModel = ViewModel<TransactionsDataProvider>

struct TransactionsDataProvider {
  let transactions: Transactions

  func filtered(by filter: String) -> [Transaction] {
    if filter.isEmpty {
      return transactions.transactions
    }

    return transactions
      .transactions
      .filter {
        $0.contains(filter)
      }
  }
}

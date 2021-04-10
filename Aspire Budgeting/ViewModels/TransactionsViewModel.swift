//
// TransactionsViewModel.swift
// Aspire Budgeting
//

import Foundation
typealias TransactionsViewModel = ViewModel<TransactionsDataProvider>

struct TransactionsDataProvider {
  let transactions: Transactions
  let dateFormatter = DateFormatter()

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

  func formattedDate(for date: Date) -> String {
    dateFormatter.dateStyle = .medium
    dateFormatter.timeStyle = .none

    return dateFormatter.string(from: date)
  }
}

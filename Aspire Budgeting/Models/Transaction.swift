//
// Transaction.swift
// Aspire Budgeting
//

import Foundation

struct Transaction {
  let amount: String
  let memo: String
  let date: Date
  let account: String
  let category: String
  let transactionType: Int
  let approvalType: Int
}

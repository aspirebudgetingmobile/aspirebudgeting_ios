//
// Transaction.swift
// Aspire Budgeting
//

import Foundation

enum ApprovalType {
  case pending
  case approved
  case reconcile

  static func approvalType(from: String) -> Self {
    switch from {
    case "✅", "🆗":
      return .approved

    case "🅿️", "⏺":
      return .pending

    default:
      return .reconcile
    }
  }
}

enum TransactionType {
  case inflow
  case outflow
}

struct Transaction {
  let amount: String
  let memo: String
  let date: Date
  let account: String
  let category: String
  let transactionType: TransactionType
  let approvalType: ApprovalType
}

struct Transactions: ConstructableFromRows {
  let transactions: [Transaction]

  init(rows: [[String]]) {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .short
    dateFormatter.timeStyle = .none

    transactions = rows.map { row in
      let date = dateFormatter.date(from: row[0]) ?? Date()
      let (amount, transactionType) =
        row[1].isEmpty ? (row[2], TransactionType.inflow) : (row[1], TransactionType.outflow)
      let category = row[3]
      let account = row[4]
      let memo = row[5]
      let approvalType = ApprovalType.approvalType(from: row[6])

      return Transaction(amount: amount,
                         memo: memo,
                         date: date,
                         account: account,
                         category: category,
                         transactionType: transactionType,
                         approvalType: approvalType)
    }
  }
}

//
// AddTransactionMetadata.swift
// Aspire Budgeting
//

import Foundation

protocol ConstructableFromBatchRequest {
  init(rowsList: [[String]])
}

struct AddTransactionMetadata: ConstructableFromBatchRequest {
  let transactionCategories: [String]
  let transactionAccounts: [String]

  init(rowsList: [[String]]) {
    transactionCategories = rowsList[0]
    transactionAccounts = rowsList[1]
  }
}

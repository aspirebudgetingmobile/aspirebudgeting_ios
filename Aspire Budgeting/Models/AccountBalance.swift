//
// AccountBalance.swift
// Aspire Budgeting
//

import Foundation

struct AccountBalance: Hashable {
  let accountName: String
  let balance: AspireNumber
  let additionalText: String
}

typealias AccountBalances = [AccountBalance]

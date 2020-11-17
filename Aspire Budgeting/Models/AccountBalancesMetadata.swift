//
//  AccountBalancesMetadata.swift
//  Aspire Budgeting
//

import Foundation

struct AccountBalancesMetadata {
  struct AccountBalance: Hashable {
    let accountName: String
    let balance: AspireNumber
  }

  let accountBalances: [AccountBalance]
  init(metadata: [[String]]) {
    accountBalances = AccountBalancesMetadata.parse(metadata: metadata)
  }

  private static func parse(metadata: [[String]]) -> [AccountBalance] {
    var accountBalances = [AccountBalance]()
    for row in metadata where row.count == 2 {
      accountBalances.append(
        AccountBalance(accountName: row[0], balance: AspireNumber(stringValue: row[1]))
      )
    }
    return accountBalances
  }
}

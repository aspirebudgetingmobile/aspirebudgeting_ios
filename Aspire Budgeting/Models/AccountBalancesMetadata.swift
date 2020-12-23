//
//  AccountBalancesMetadata.swift
//  Aspire Budgeting
//

import Foundation

struct AccountBalance: Hashable {
  let accountName: String
  let balance: AspireNumber
  let additionalText: String
}

typealias AccountBalances = [AccountBalance]

struct AccountBalancesMetadata {
  let accountBalances: AccountBalances
  init(metadata: [[String]]) {
    accountBalances = AccountBalancesMetadata.parse(metadata: metadata)
  }

  private static func parse(metadata: [[String]]) -> [AccountBalance] {
    var accountBalances = [AccountBalance]()
    var accountName: String?
    var balance: AspireNumber?
    var additionalText: String?

    for row in metadata {
      if row.count == 2 {
        accountName = row[0]
        balance = AspireNumber(stringValue: row[1])
      }
      else if row.count == 1 {
        additionalText = row[0]
        accountBalances.append(
          AccountBalance(accountName: accountName!,
                         balance: balance!,
                         additionalText: additionalText!)
        )
      }

    }
    return accountBalances
  }
}

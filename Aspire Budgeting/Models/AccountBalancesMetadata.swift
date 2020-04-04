//
//  AccountBalancesMetadata.swift
//  Aspire Budgeting
//
//  Created by TeraMo Labs on 4/4/20.
//  Copyright © 2020 TeraMo Labs. All rights reserved.
//

import Foundation

struct AccountBalancesMetadata {
  let accountBalances: [(account: String, balance: String)]
  init(metadata: [[String]]) {
    accountBalances = AccountBalancesMetadata.parse(metadata: metadata)
  }
  
  private static func parse(metadata: [[String]]) -> [(String, String)] {
    var accountBalances = [(String, String)]()
    for row in metadata {
      accountBalances.append((row[0], row[1]))
    }
    return accountBalances
  }
}

//
// AccountBalancesViewModel.swift
// Aspire Budgeting
//

import Foundation

typealias AccountBalancesViewModel = ViewModel<AccountBalancesDataProvider>

struct AccountBalancesDataProvider {
  let accountBalances: AccountBalances
}

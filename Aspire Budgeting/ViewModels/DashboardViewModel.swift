//
// DashboardViewModel.swift
// Aspire Budgeting
//

import Foundation

struct DashboardViewModel {

  let currentState: ViewModelState
  let metadata: DashboardMetadata?
  let error: Error?

  var cardViewItems: [CardView.CardViewItem] {
    var items = [CardView.CardViewItem]()
    for (idx, group) in metadata!.groups.enumerated() {
      let title = group
      let lowerbound = metadata!.groupedAvailableTotals[idx]
      let upperbound = metadata!.groupedBudgetedTotals[idx]
      var progressFactor = lowerbound / upperbound
      if progressFactor < 0 {
        progressFactor = 0
      }
      if progressFactor > 1 {
        progressFactor = 1
      }
      if lowerbound.decimalValue > upperbound.decimalValue {
        progressFactor = 1
      }

      items.append(.init(title: title,
                         lowerBound: lowerbound.stringValue,
                         upperBound: upperbound.stringValue,
                         progressFactor: progressFactor))
    }
    return items
  }

  private let refreshAction: (() -> Void)

  init(result: Result<DashboardMetadata>?,
       refreshAction: @escaping (() -> Void)) {

    self.refreshAction = refreshAction

    if let result = result {
      switch result {
      case .failure(let error):
        self.error = error
        self.metadata = nil
        self.currentState = .error

      case .success(let metadata):
        self.metadata = metadata
        self.error = nil
        self.currentState = .dataRetrieved
      }
    } else {
      self.metadata = nil
      self.error = nil
      self.currentState = .isLoading
    }
  }

  init(refreshAction: @escaping () -> Void) {
    self.init(result: nil, refreshAction: refreshAction)
  }

  func refresh() {
    refreshAction()
  }

//  private func getIndex(for group: String) -> Int {
//    return metadata!.groups.firstIndex(of: group)!
//  }
//
//  func categoryRows(for group: String) -> [DashboardCategoryRow] {
//    return metadata!.groupedCategoryRows[getIndex(for: group)]
//  }
//
//  func availableTotals(for group: String) -> DashboardCardView.Totals {
//    let index = getIndex(for: group)
//    let availableTotal = metadata!.groupedAvailableTotals[index]
//    let budgetedTotal = metadata!.groupedBudgetedTotals[index]
//    let spentTotal = metadata!.groupedSpentTotals[index]
//    return DashboardCardView.Totals(
//      availableTotal: availableTotal,
//      budgetedTotal: budgetedTotal,
//      spentTotals: spentTotal
//    )
//  }
}

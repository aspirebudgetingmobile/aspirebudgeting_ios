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
      let availableTotal = metadata!.groupedAvailableTotals[idx]
      let budgetedTotal = metadata!.groupedBudgetedTotals[idx]
      let spentTotal = metadata!.groupedSpentTotals[idx]
      var progressFactor = availableTotal / budgetedTotal

      if progressFactor < 0 {
        progressFactor = 0
      }

      if progressFactor > 1 ||
          availableTotal >= budgetedTotal {
        progressFactor = 1
      }

      items.append(.init(title: title,
                         availableTotal: availableTotal.stringValue,
                         budgetedTotal: budgetedTotal.stringValue,
                         spentTotal: spentTotal.stringValue,
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
}

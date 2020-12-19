//
// DashboardViewModel.swift
// Aspire Budgeting
//

import Foundation

struct DashboardViewModel {

  let currentState: ViewModelState
  let dashboard: Dashboard?
  let error: Error?

  var cardViewItems: [BaseCardView.CardViewItem] {
    var items = [BaseCardView.CardViewItem]()
    for (idx, group) in dashboard!.groups.enumerated() {
      let title = group.title
      let availableTotal = dashboard!.availableTotalForGroup(at: idx)
      let budgetedTotal = dashboard!.budgetedTotalForGroup(at: idx)
      let spentTotal = dashboard!.spentTotalForGroup(at: idx)
      var progressFactor = availableTotal /| budgetedTotal

      items.append(.init(title: title,
                         availableTotal: availableTotal,
                         budgetedTotal: budgetedTotal,
                         spentTotal: spentTotal,
                         progressFactor: progressFactor,
                         categories: group.categories))
    }
    return items
  }

  func filteredCategories(filter: String) -> [Category] {
    guard !filter.isEmpty else { return [Category]() }
    var categories = [Category]()
    if let groups = dashboard?.groups {
      categories = groups.flatMap { $0.categories
        .filter { $0.categoryName
          .range(of: filter, options: .caseInsensitive) != nil
        }
      }
    }
    return categories
  }

  private let refreshAction: (() -> Void)

  init(result: Result<Dashboard>?,
       refreshAction: @escaping (() -> Void)) {

    self.refreshAction = refreshAction

    if let result = result {
      switch result {
      case .failure(let error):
        self.error = error
        self.dashboard = nil
        self.currentState = .error

      case .success(let dashboard):
        self.dashboard = dashboard
        self.error = nil
        self.currentState = .dataRetrieved
      }
    } else {
      self.dashboard = nil
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

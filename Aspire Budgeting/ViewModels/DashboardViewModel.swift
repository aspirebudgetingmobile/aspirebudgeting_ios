//
// DashboardViewModel.swift
// Aspire Budgeting
//

import Foundation

typealias DashboardViewModel = ViewModel<DashboardDataProvider>

struct DashboardDataProvider {
  let dashboard: Dashboard

  var cardViewItems: [DashboardCardView.DashboardCardItem] {
    var items = [DashboardCardView.DashboardCardItem]()
    for (idx, group) in dashboard.groups.enumerated() {
      let title = group.title
      let availableTotal = dashboard.availableTotalForGroup(at: idx)
      let budgetedTotal = dashboard.budgetedTotalForGroup(at: idx)
      let spentTotal = dashboard.spentTotalForGroup(at: idx)
      let progressFactor = availableTotal /| budgetedTotal

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
    categories = dashboard.groups.flatMap { $0.categories
      .filter { $0.categoryName
        .range(of: filter, options: .caseInsensitive) != nil
      }
    }
    return categories
  }
}

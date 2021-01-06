//
// DashboardViewModel.swift
// Aspire Budgeting
//

import Foundation

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

//struct DashboardViewModel: AspireViewModel {
//  let currentState: ViewModelState
//  var dataProvider: Dashboard?
//  var error: Error?
//  var refresh: () -> Void
//
//  init(result: Result<Dashboard>?,
//       refreshAction: @escaping (() -> Void)) {
//    self.refresh = refreshAction
//
//    if let result = result {
//      switch result {
//      case .failure(let error):
//        self.error = error
//        self.dataProvider = nil
//        self.currentState = .error
//
//      case .success(let dashboard):
//        self.dataProvider = dashboard
//        self.error = nil
//        self.currentState = .dataRetrieved
//      }
//    } else {
//      self.dataProvider = nil
//      self.error = nil
//      self.currentState = .isLoading
//    }
//  }
//
//  var cardViewItems: [DashboardCardView.DashboardCardItem] {
//    var items = [DashboardCardView.DashboardCardItem]()
//    for (idx, group) in dataProvider!.groups.enumerated() {
//      let title = group.title
//      let availableTotal = dataProvider!.availableTotalForGroup(at: idx)
//      let budgetedTotal = dataProvider!.budgetedTotalForGroup(at: idx)
//      let spentTotal = dataProvider!.spentTotalForGroup(at: idx)
//      var progressFactor = availableTotal /| budgetedTotal
//
//      items.append(.init(title: title,
//                         availableTotal: availableTotal,
//                         budgetedTotal: budgetedTotal,
//                         spentTotal: spentTotal,
//                         progressFactor: progressFactor,
//                         categories: group.categories))
//    }
//    return items
//  }
//
//  func filteredCategories(filter: String) -> [Category] {
//    guard !filter.isEmpty else { return [Category]() }
//    var categories = [Category]()
//    if let groups = dataProvider?.groups {
//      categories = groups.flatMap { $0.categories
//        .filter { $0.categoryName
//          .range(of: filter, options: .caseInsensitive) != nil
//        }
//      }
//    }
//    return categories
//  }
//}

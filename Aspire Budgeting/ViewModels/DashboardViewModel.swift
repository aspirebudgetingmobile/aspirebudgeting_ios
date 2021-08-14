//
// DashboardViewModel.swift
// Aspire Budgeting
//

import Combine

final class DashboardViewModel: ObservableObject {
  let publisher: AnyPublisher<Dashboard, Error>
  var cancellables = Set<AnyCancellable>()

  @Published private(set) var dashboard: Dashboard?
  @Published private(set) var error: Error?

  var isLoading: Bool {
    dashboard == nil && error == nil
  }

  init(publisher: AnyPublisher<Dashboard, Error>) {
    self.publisher = publisher
  }

  var cardViewItems: [DashboardCardView.DashboardCardItem] {
    guard let dashboard = dashboard else {
      return .init()
    }
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
    guard !filter.isEmpty, let dashboard = dashboard else { return .init() }
    var categories = [Category]()
    categories = dashboard.groups.flatMap { $0.categories
      .filter { $0.categoryName
        .range(of: filter, options: .caseInsensitive) != nil
      }
    }
    return categories
  }

  func refresh() {
    cancellables.removeAll()

    publisher
      .sink { completion in
        switch completion {
        case let .failure(error):
          self.error = error

        case .finished:
          Logger.info("Dashboard fetched.")
        }
      } receiveValue: {
        self.dashboard = $0
      }
      .store(in: &cancellables)
  }
}

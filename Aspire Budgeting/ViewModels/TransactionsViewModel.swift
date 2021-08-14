//
// TransactionsViewModel.swift
// Aspire Budgeting
//

import Combine
import Foundation

final class TransactionsViewModel: ObservableObject {
  let publisher: AnyPublisher<Transactions, Error>
  let dateFormatter = DateFormatter()
  var cancellables = Set<AnyCancellable>()

  @Published private(set) var transactions: Transactions?
  @Published private(set) var error: Error?

  var isLoading: Bool {
    transactions == nil && error == nil
  }

  init(publisher: AnyPublisher<Transactions, Error>) {
    self.publisher = publisher
  }

  func filtered(by filter: String) -> [Transaction] {
    guard let transactions = transactions else {
      return .init()
    }

    if filter.isEmpty {
      return transactions.transactions
    }

    return transactions
      .transactions
      .filter {
        $0.contains(filter)
      }
  }

  func formattedDate(for date: Date) -> String {
    dateFormatter.dateStyle = .medium
    dateFormatter.timeStyle = .none

    return dateFormatter.string(from: date)
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
        self.transactions = $0
      }
      .store(in: &cancellables)
  }
}

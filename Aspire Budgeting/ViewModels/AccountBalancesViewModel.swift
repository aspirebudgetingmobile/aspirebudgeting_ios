//
// AccountBalancesViewModel.swift
// Aspire Budgeting
//
import Combine

//typealias AccountBalancesViewModel = ViewModel<AccountBalancesDataProvider>
//
//struct AccountBalancesDataProvider {
//  let accountBalances: AccountBalances
//}

final class AccountBalancesViewModel: ObservableObject {

  let publisher: AnyPublisher<AccountBalances, Error>
  var cancellables = Set<AnyCancellable>()

  @Published private(set) var accountBalances = AccountBalances()
  @Published private(set) var error: Error?

  var isLoading: Bool {
    accountBalances.isEmpty && error == nil
  }

  init(publisher: AnyPublisher<AccountBalances, Error>) {
    self.publisher = publisher
  }

  func refresh() {
    cancellables.removeAll()

    publisher
      .sink { completion in
        switch completion {
        case let .failure(error):
          self.error = error

        case .finished:
          Logger.info("Account Balances retrieved")
        }
      } receiveValue: {
        self.accountBalances = $0
      }
      .store(in: &cancellables)

  }
}

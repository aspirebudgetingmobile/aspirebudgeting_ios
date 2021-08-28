//
// CategoryTransferViewModel.swift
// Aspire Budgeting
//
import Combine

final class CategoryTransferViewModel: ObservableObject {
  let categoriesPublisher: AnyPublisher<TrxCategories, Error>
  let submitter: (CategoryTransfer) -> AnyPublisher<Void, Error>

  var getCategoriesSubscription: AnyCancellable?
  var submitTransferSubscription: AnyCancellable?

  @Published private(set) var categories: TrxCategories?
  @Published private(set) var error: Error?
  @Published private(set) var signal: ()?

  init(
    categoriesPublisher: AnyPublisher<TrxCategories, Error>,
    submitter: @escaping (CategoryTransfer) -> AnyPublisher<Void, Error>
  ) {
    self.categoriesPublisher = categoriesPublisher
    self.submitter = submitter
  }

  func getCategories() {
    getCategoriesSubscription = categoriesPublisher
      .subscribe {
        Logger.info("Categories fetched.")
      } onFailure: {
        self.error = $0
      } onValue: {
        self.categories = $0
      }
  }

  func submit(categoryTransfer: CategoryTransfer) {
    submitTransferSubscription =
      submitter(categoryTransfer)
      .subscribe {
        Logger.info("Category Transfer submitted.")
      } onFailure: { error in
        self.error = error
      } onValue: {
        self.signal = $0
      }
  }
}

extension Publisher {
  func subscribe(
    onCompletion: @escaping () -> Void,
    onFailure: @escaping (Error) -> Void,
    onValue: @escaping (Output) -> Void) -> AnyCancellable {
    self.sink { completion in
      switch completion {
      case .finished:
        onCompletion()

      case let .failure(error):
        onFailure(error)
      }
    } receiveValue: { value in
      onValue(value)
    }
  }
}

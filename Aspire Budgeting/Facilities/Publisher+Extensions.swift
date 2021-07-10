//
// Publisher+Extensions.swift
// Aspire Budgeting
//

import Combine

extension Publisher {
  func toResult() -> AnyPublisher<Result<Output>, Never> {
    map(Result.success)
      .catch { Just(Result.failure($0)) }
      .eraseToAnyPublisher()
  }
}

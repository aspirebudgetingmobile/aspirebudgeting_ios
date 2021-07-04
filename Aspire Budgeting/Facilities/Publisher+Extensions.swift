//
// Publisher+Extensions.swift
// Aspire Budgeting
//

import Combine

extension Publisher {
  func toResult() -> AnyPublisher<Result<Output>, Never> {
    return map(Result.success)
      .catch { Just(Result.failure($0)) }
      .eraseToAnyPublisher()
  }
}

//
// DashboardViewModel.swift
// Aspire Budgeting
//

import Foundation

struct DashboardViewModel {

  let currentState: ViewModelState
  let metadata: DashboardMetadata?
  let error: Error?

  init(result: Result<DashboardMetadata>?) {
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

  init() {
    self.init(result: nil)
  }
}

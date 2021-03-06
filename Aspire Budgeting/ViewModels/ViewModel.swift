//
// ViewModel.swift
// Aspire Budgeting
//

import Foundation

protocol AspireViewModel {
  associatedtype DataProvider

  var dataProvider: DataProvider? { get }
  var error: Error? { get }
  var refresh: () -> Void { get }

  init(result: Result<DataProvider>?,
       refreshAction: @escaping () -> Void)

  init(refreshAction: @escaping () -> Void)
}

extension AspireViewModel {
  init(refreshAction: @escaping () -> Void) {
    self.init(result: nil, refreshAction: refreshAction)
  }
}

struct ViewModel<T>: AspireViewModel {
  typealias DataProvider = T

  let dataProvider: T?
  let error: Error?
  let refresh: () -> Void

  init(result: Result<T>?, refreshAction: @escaping () -> Void) {
    self.refresh = refreshAction

    if let result = result {
      switch result {
      case .failure(let error):
        self.error = error
        self.dataProvider = nil

      case .success(let dashboard):
        self.dataProvider = dashboard
        self.error = nil
      }
    } else {
      self.dataProvider = nil
      self.error = nil
    }
  }
}

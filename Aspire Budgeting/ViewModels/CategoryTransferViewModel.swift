//
// CategoryTransferViewModel.swift
// Aspire Budgeting
//


import Foundation

typealias CategoryTransferViewModel = ViewModel<CategoryTransferDataProvider>
struct CategoryTransferDataProvider {
  let categories: [Category]
  let submit: (Transaction, @escaping SubmitResultHandler) -> Void

  init(categories: [Category],
       submitAction: @escaping (Transaction, @escaping SubmitResultHandler) -> Void) {
    self.categories = categories
    self.submit = submitAction
  }
}

//
// TrxCategory.swift
// Aspire Budgeting
//

struct TrxCategory {
  let title: String
}

struct TrxCategories: ConstructableFromRows {
  let categories: [TrxCategory]

  init(rows: [[String]]) {
    categories = rows.flatMap { $0.map(TrxCategory.init) }
  }
}

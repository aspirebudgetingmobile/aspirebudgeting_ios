//
//  Category.swift
//  Aspire Budgeting
//

struct Category: Hashable {
  let categoryName: String
  let available: String
  let spent: String
  let budgeted: String
  let monthly: String

  init(row: [String]) {
    categoryName = row[2]
    available = row[3]
    spent = row[6]
    monthly = row[7]
    budgeted = row[9]
  }
}

//
//  Category.swift
//  Aspire Budgeting
//

struct Category: Hashable {
  let categoryName: String
  let available: AspireNumber
  let spent: AspireNumber
  let budgeted: AspireNumber
  let monthly: AspireNumber

  init(row: [String]) {
    categoryName = row[2]
    available = AspireNumber(stringValue: row[3])
    spent = AspireNumber(stringValue: row[6])
    monthly = AspireNumber(stringValue: row[7])
    budgeted = AspireNumber(stringValue: row[9])
  }
}

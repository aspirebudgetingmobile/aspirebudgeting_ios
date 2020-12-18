//
//  Dashboard.swift
//  Aspire Budgeting
//

import Foundation

struct Dashboard {
  struct Group {
    let title: String
    let categories: [Category]
  }

  private enum TotalType {
    case available, budgeted, spent
  }

  let groups: [Group]
  private let numFormatter = NumberFormatter()

  init(rows: [[String]]) {
    groups = Dashboard.parse(rows: rows)
    numFormatter.numberStyle = .currency
    numFormatter.minimumFractionDigits = 2
  }

  private static func parse(rows: [[String]]) -> [Group] {
    var title = ""
    var categories = [Category]()
    var groups = [Group]()

    for row in rows where row.count == 10 {
      if row[0] == "✦" { //Group Row
        if !title.isEmpty {
          groups.append(Group(title: title, categories: categories))
          categories.removeAll()
        }
        title = row[2]
      } else {
        let categoryRow = Category(row: row)
        categories.append(categoryRow)
      }
    }

    groups.append(Group(title: title, categories: categories))
    return groups
  }
}

// MARK: Computing Functions
extension Dashboard {
  private func getTotalOf(type: TotalType, at idx: Int) -> AspireNumber {
    guard idx < groups.count else { fatalError("Index out of bounds") }

    let categories = groups[idx].categories
    var total: Decimal = 0
    var numberString = "0"

    for category in categories {
      let categoryNumber: AspireNumber
      switch type {
      case .available:
        categoryNumber = category.available
      case .budgeted:
        categoryNumber = category.budgeted
      case .spent:
        categoryNumber = category.spent
      }

      total += categoryNumber.decimalValue
    }

    if let numString = numFormatter.string(from: total as NSDecimalNumber) {
      numberString = numString
    }

    return AspireNumber(stringValue: numberString, decimalValue: total)
  }

  func availableTotalForGroup(at idx: Int) -> AspireNumber {
    getTotalOf(type: .available, at: idx)
  }

  func budgetedTotalForGroup(at idx: Int) -> AspireNumber {
    getTotalOf(type: .budgeted, at: idx)
  }

  func spentTotalForGroup(at idx: Int) -> AspireNumber {
    getTotalOf(type: .spent, at: idx)
  }
}

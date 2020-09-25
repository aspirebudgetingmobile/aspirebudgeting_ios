//
//  DashboardGroupsAndCategories.swift
//  Aspire Budgeting
//

import Foundation
import os.log

struct DashboardMetadata {
  let groups: [String]
  let groupedCategoryRows: [[CategoryRow]]
  let groupedAvailableTotals: [AspireNumber]
  let groupedBudgetedTotals: [AspireNumber]
  let groupedSpentTotals: [AspireNumber]

  init(rows: [[String]]) {
    (
      groups,
      groupedCategoryRows,
      groupedAvailableTotals,
      groupedBudgetedTotals,
      groupedSpentTotals
    ) = DashboardMetadata.parse(rows: rows)
  }

  private static func parse(
    rows: [[String]]
  ) -> ([String], [[CategoryRow]], [AspireNumber], [AspireNumber], [AspireNumber]) {
    var lastIndex = -1
    var tempGroups = [String]()
    var tempGroupedCategoryRow = [[CategoryRow]]()
    var tempAvailableTotals = [AspireNumber]()
    var tempBudgetedTotals = [AspireNumber]()
    var tempSpentTotals = [AspireNumber]()

    var availableTotal = Decimal(0.0)
    var budgetedTotal = Decimal(0.0)
    var spentTotal = Decimal(0.0)

    let numFormatter = NumberFormatter()
    numFormatter.numberStyle = .currency
    numFormatter.minimumFractionDigits = 2

    for row in rows {
      if row[0] == "✦" {
        os_log(
          "Encountered a Group row",
          log: .dashboardMetadata,
          type: .default
        )
        lastIndex += 1

        tempGroups.append(row[2])

        tempGroupedCategoryRow.append([CategoryRow]())
        tempAvailableTotals.append(AspireNumber())
        tempBudgetedTotals.append(AspireNumber())
        tempSpentTotals.append(AspireNumber())

        availableTotal = 0
        budgetedTotal = 0
        spentTotal = 0

      } else {
        let categoryRow = CategoryRow(row: row)
        tempGroupedCategoryRow[lastIndex].append(categoryRow)
        availableTotal += numFormatter.number(from: categoryRow.available)?.decimalValue ?? 0
        budgetedTotal += numFormatter.number(from: categoryRow.budgeted)?.decimalValue ?? 0
        spentTotal += numFormatter.number(from: categoryRow.spent)?.decimalValue ?? 0

        let availableTotalString =
          numFormatter.string(from: availableTotal as NSDecimalNumber) ?? ""
        os_log(
          "Checking availableTotalString empty: %d",
          log: .dashboardMetadata,
          type: .default,
          availableTotalString.isEmpty
        )

        let budgetedTotalString = numFormatter.string(from: budgetedTotal as NSDecimalNumber) ?? ""
        os_log(
          "Checking budgetedTotalString empty: %d",
          log: .dashboardMetadata,
          type: .default,
          budgetedTotalString.isEmpty
        )

        let spentTotalString = numFormatter.string(from: spentTotal as NSDecimalNumber) ?? ""
        os_log(
          "Checking spentTotalString empty: %d",
          log: .dashboardMetadata,
          type: .default,
          spentTotalString.isEmpty
        )

        tempAvailableTotals[lastIndex] = AspireNumber(
          stringValue: availableTotalString,
          decimalValue: availableTotal
        )
        tempBudgetedTotals[lastIndex] = AspireNumber(
          stringValue: budgetedTotalString,
          decimalValue: budgetedTotal
        )
        tempSpentTotals[lastIndex] = AspireNumber(
          stringValue: spentTotalString,
          decimalValue: spentTotal
        )
      }
    }
    return (
      tempGroups,
      tempGroupedCategoryRow,
      tempAvailableTotals,
      tempBudgetedTotals,
      tempSpentTotals
    )
  }
}

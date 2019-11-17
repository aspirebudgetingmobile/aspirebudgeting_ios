//
//  DashboardGroupsAndCategories.swift
//  Aspire Budgeting
//
//  Created by TeraMo Labs on 11/3/19.
//  Copyright © 2019 TeraMo Labs. All rights reserved.
//
import Foundation

struct DashboardGroupsAndCategories {
  let groups: [String]
  let groupedCategoryRows: [[DashboardCategoryRow]]
  let groupedAvailableTotals: [String]
  let groupedBudgetedTotals: [String]
  
  init(rows: [[String]]) {
    (groups, groupedCategoryRows, groupedAvailableTotals, groupedBudgetedTotals) = DashboardGroupsAndCategories.parse(rows: rows)
  }
  
  private static func parse(rows: [[String]]) -> ([String], [[DashboardCategoryRow]], [String], [String]) {
    var lastIndex = -1
    var tempGroups = [String]()
    var tempGroupedCategoryRow = [[DashboardCategoryRow]]()
    var tempAvailableTotals = [String]()
    var tempBudgetedTotals = [String]()
    
    var availableTotal = Decimal(0.0)
    var budgetedTotal = Decimal(0.0)
    
    let numFormatter = NumberFormatter()
    numFormatter.numberStyle = .currency
    
    for row in rows {
      if row.count == 1 {
        lastIndex += 1
        tempGroups.append(row[0])
        tempGroupedCategoryRow.append([DashboardCategoryRow]())
        tempAvailableTotals.append("")
        tempBudgetedTotals.append("")
        availableTotal = 0
        budgetedTotal = 0
      } else {
        let categoryRow = DashboardCategoryRow(row: row)
        tempGroupedCategoryRow[lastIndex].append(categoryRow)
        availableTotal += numFormatter.number(from: categoryRow.available)?.decimalValue ?? 0
        budgetedTotal += numFormatter.number(from: categoryRow.budgeted)?.decimalValue ?? 0
        
        tempAvailableTotals[lastIndex] = numFormatter.string(from: availableTotal as NSDecimalNumber) ?? ""
        tempBudgetedTotals[lastIndex] = numFormatter.string(from: budgetedTotal as NSDecimalNumber) ?? ""
      }
    }
    return (tempGroups, tempGroupedCategoryRow, tempAvailableTotals, tempBudgetedTotals)
  }
}

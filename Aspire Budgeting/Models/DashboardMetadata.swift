//
//  DashboardGroupsAndCategories.swift
//  Aspire Budgeting
//
//  Created by TeraMo Labs on 11/3/19.
//  Copyright © 2019 TeraMo Labs. All rights reserved.
//
import Foundation

struct DashboardMetadata {
  let groups: [String]
  let groupedCategoryRows: [[DashboardCategoryRow]]
  let groupedAvailableTotals: [AspireNumber]
  let groupedBudgetedTotals: [AspireNumber]
  
  init(rows: [[String]]) {
    (groups, groupedCategoryRows, groupedAvailableTotals, groupedBudgetedTotals) = DashboardMetadata.parse(rows: rows)
  }
  
  private static func parse(rows: [[String]]) -> ([String], [[DashboardCategoryRow]], [AspireNumber], [AspireNumber]) {
    var lastIndex = -1
    var tempGroups = [String]()
    var tempGroupedCategoryRow = [[DashboardCategoryRow]]()
    var tempAvailableTotals = [AspireNumber]()
    var tempBudgetedTotals = [AspireNumber]()
    
    var availableTotal = Decimal(0.0)
    var budgetedTotal = Decimal(0.0)
    
    let numFormatter = NumberFormatter()
    numFormatter.numberStyle = .currency
    
    for row in rows {
      if row.count == 1 {
        lastIndex += 1
        tempGroups.append(row[0])
        tempGroupedCategoryRow.append([DashboardCategoryRow]())
        tempAvailableTotals.append(AspireNumber())
        tempBudgetedTotals.append(AspireNumber())
        availableTotal = 0
        budgetedTotal = 0
      } else {
        let categoryRow = DashboardCategoryRow(row: row)
        tempGroupedCategoryRow[lastIndex].append(categoryRow)
        availableTotal += numFormatter.number(from: categoryRow.available)?.decimalValue ?? 0
        budgetedTotal += numFormatter.number(from: categoryRow.budgeted)?.decimalValue ?? 0
        
        let availableTotalString = numFormatter.string(from: availableTotal as NSDecimalNumber) ?? ""
        let budgetedTotalString = numFormatter.string(from: budgetedTotal as NSDecimalNumber) ?? ""
        
        tempAvailableTotals[lastIndex] = AspireNumber(stringValue: availableTotalString, decimalValue: availableTotal)
        tempBudgetedTotals[lastIndex] = AspireNumber(stringValue: budgetedTotalString, decimalValue: budgetedTotal)
      }
    }
    return (tempGroups, tempGroupedCategoryRow, tempAvailableTotals, tempBudgetedTotals)
  }
}

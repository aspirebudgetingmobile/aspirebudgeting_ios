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
  let groupedAvailableTotals: [Decimal]
  
  init(rows: [[String]]) {
    (groups, groupedCategoryRows, groupedAvailableTotals) = DashboardGroupsAndCategories.parse(rows: rows)
  }
  
  private static func parse(rows: [[String]]) -> ([String], [[DashboardCategoryRow]], [Decimal]) {
    var lastIndex = -1
    var tempGroups = [String]()
    var tempGroupedCategoryRow = [[DashboardCategoryRow]]()
    var tempAvailableTotals = [Decimal]()
    
    var availableTotal = Decimal(0.0)
    let numFormatter = NumberFormatter()
    numFormatter.numberStyle = .currency
    
    for row in rows {
      if row.count == 1 {
        lastIndex += 1
        tempGroups.append(row[0])
        tempGroupedCategoryRow.append([DashboardCategoryRow]())
        tempAvailableTotals.append(0)
        availableTotal = 0
      } else {
        let categoryRow = DashboardCategoryRow(row: row)
        tempGroupedCategoryRow[lastIndex].append(categoryRow)
        availableTotal += numFormatter.number(from: categoryRow.available)?.decimalValue ?? 0
        tempAvailableTotals[lastIndex] = availableTotal
      }
    }
    return (tempGroups, tempGroupedCategoryRow, tempAvailableTotals)
  }
}

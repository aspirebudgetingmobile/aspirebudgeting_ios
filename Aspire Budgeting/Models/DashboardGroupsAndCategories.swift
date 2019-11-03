//
//  DashboardGroupsAndCategories.swift
//  Aspire Budgeting
//
//  Created by TeraMo Labs on 11/3/19.
//  Copyright © 2019 TeraMo Labs. All rights reserved.
//

struct DashboardGroupsAndCategories {
  let groups: [String]
  let groupedCategoryRows: [[DashboardCategoryRow]]
  
  init(rows: [[String]]) {
    (groups, groupedCategoryRows) = DashboardGroupsAndCategories.parse(rows: rows)
  }
  
  private static func parse(rows: [[String]]) -> ([String], [[DashboardCategoryRow]]) {
    var lastIndex = -1
    var tempGroups = [String]()
    var tempGroupedCategoryRow = [[DashboardCategoryRow]]()
    for row in rows {
      if row.count == 1 {
        lastIndex += 1
        tempGroups.append(row[0])
        tempGroupedCategoryRow.append([DashboardCategoryRow]())
      } else {
        let categoryRow = DashboardCategoryRow(row: row)
        tempGroupedCategoryRow[lastIndex].append(categoryRow)
      }
    }
    return (tempGroups, tempGroupedCategoryRow)
  }
}

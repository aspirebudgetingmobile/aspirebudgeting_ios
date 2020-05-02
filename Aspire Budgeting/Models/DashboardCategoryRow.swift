//
//  CategoryRow.swift
//  Aspire Budgeting
//
//  Created by TeraMo Labs on 11/3/19.
//  Copyright © 2019 TeraMo Labs. All rights reserved.
//

struct DashboardCategoryRow: Hashable {
  let categoryName: String
  let available: String
  let spent: String
  let budgeted: String

  init(row: [String]) {
    categoryName = row[2]
    available = row[3]
    spent = row[6]
    budgeted = row[9]
  }
}

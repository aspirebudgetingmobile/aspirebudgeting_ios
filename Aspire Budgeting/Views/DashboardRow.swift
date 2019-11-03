//
//  DashboardRow.swift
//  Aspire Budgeting
//
//  Created by TeraMo Labs on 11/2/19.
//  Copyright © 2019 TeraMo Labs. All rights reserved.
//
import SwiftUI

struct DashboardRow: View {
  var categoryRow: DashboardCategoryRow
  
  var body: some View {
    VStack(alignment: .leading) {
      Text(categoryRow.categoryName).font(.headline)
      HStack {
        Text(categoryRow.available).font(.subheadline)
        Spacer()
        Text(categoryRow.spent).font(.subheadline)
        Spacer()
        Text(categoryRow.budgeted).font(.subheadline)
      }
    }
  }
}

//struct DashboardRow_Previews: PreviewProvider {
//    static var previews: some View {
//        DashboardRow()
//    }
//}

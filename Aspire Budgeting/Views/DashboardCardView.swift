//
//  DashboardCardVIew.swift
//  Aspire Budgeting
//
//  Created by TeraMo Labs on 11/17/19.
//  Copyright © 2019 TeraMo Labs. All rights reserved.
//

import SwiftUI

struct DashboardCardView: View {
  struct Totals {
    var availableTotal: AspireNumber
    var budgetedTotal: AspireNumber
  }
  
  let categoryName: String
  let totals: Totals
  let categoryRows: [DashboardCategoryRow]
  
  @State var expanded = false
  
  var body: some View {
    VStack {
      if !self.expanded {
        CollapsedCardView(categoryName: categoryName, totals: totals, categoryRows: categoryRows)
      } else {
        ForEach(self.categoryRows, id: \.self) { row in
          DashboardRow(categoryRow: row).padding().transition(.identity)
        }
      }
    }.background(Color.white.opacity(0.07))
      .cornerRadius(10)
      .shadow(radius: 5)
      .padding()
      .gesture(TapGesture().onEnded({ (_) in
        withAnimation {
          self.expanded.toggle()
        }
      }))
  }
}

//struct DashboardCardVIew_Previews: PreviewProvider {
//    static var previews: some View {
//        DashboardCardVIew()
//    }
//}

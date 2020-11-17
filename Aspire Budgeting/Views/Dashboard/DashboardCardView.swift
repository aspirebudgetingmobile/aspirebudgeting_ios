//
//  DashboardCardVIew.swift
//  Aspire Budgeting
//

import SwiftUI

struct DashboardCardView: View {
  struct Totals {
    var availableTotal: AspireNumber
    var budgetedTotal: AspireNumber
    var spentTotals: AspireNumber
  }

  let categoryName: String
  let totals: Totals
  let categoryRows: [Category]

  @State var expanded = false

  var body: some View {
    VStack {
      if !self.expanded {
        CollapsedCardView(categoryName: categoryName, totals: totals, categoryRows: categoryRows)
      } else {
        ExpandedCardView(categoryName: categoryName, totals: totals, categoryRows: categoryRows)
      }
    }.background(Color.white.opacity(0.07))
      .cornerRadius(10)
      .shadow(radius: 5)
      .padding()
      .gesture(TapGesture().onEnded { _ in
        withAnimation {
          self.expanded.toggle()
        }
      })
  }
}

// struct DashboardCardVIew_Previews: PreviewProvider {
//    static var previews: some View {
//        DashboardCardVIew()
//    }
// }

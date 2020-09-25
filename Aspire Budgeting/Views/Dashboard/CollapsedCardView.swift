//
//  CollapsedDashboardView.swift
//  Aspire Budgeting
//
//  Created by TeraMo Labs on 11/27/19.
//  Copyright © 2019 TeraMo Labs. All rights reserved.
//

import SwiftUI

struct CollapsedCardView: View {
  let categoryName: String
  let totals: DashboardCardView.Totals
  let categoryRows: [Category]

  func getGradient(for number: AspireNumber) -> LinearGradient {
    if number.isNegative {
      return Colors.redGradient
    }
    return Colors.greenGradient
  }

  var body: some View {
    VStack {
      HStack {
        VStack(alignment: .leading) {
          Text(categoryName)
            .tracking(1)
            .font(.rubikRegular(size: 20))
            .padding([.top])
            .foregroundColor(.white)
          Text("Spent")
            .tracking(1)
            .font(.rubikLight(size: 13))
            .padding([.top])
            .foregroundColor(.white)
          GradientTextView(
            string: totals.spentTotals.stringValue,
            tracking: 1.18,
            font: .rubikMedium(size: 15),
            paddingEdges: .top,
            paddingLength: nil,
            gradient: Colors.redGradient
          )
        }.padding([.horizontal])
        Spacer()
        VStack {
          GradientTextView(
            string: totals.availableTotal.stringValue,
            tracking: 2.34,
            font: .rubikMedium(size: 30),
            paddingEdges: .trailing,
            paddingLength: nil,
            gradient: self.getGradient(for: totals.availableTotal)
          )
          Text("Available")
            .tracking(1)
            .font(.rubikLight(size: 13))
            .foregroundColor(.white)
        }
      }
      Text("View \(categoryRows.count) categories")
        .tracking(1)
        .font(.rubikLight(size: 13))
        .foregroundColor(.white)
        .padding(.bottom, 5)
        .opacity(0.6)
    }
  }
}

// struct CollapsedCardView_Previews: PreviewProvider {
//  static var previews: some View {
//    CollapsedCardView()
//  }
// }

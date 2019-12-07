//
//  ExpandedCardView.swift
//  Aspire Budgeting
//
//  Created by TeraMo Labs on 11/27/19.
//  Copyright © 2019 TeraMo Labs. All rights reserved.
//

import SwiftUI

struct ExpandedCardView: View {
  let categoryName: String
  let totals: DashboardCardView.Totals
  let categoryRows: [DashboardCategoryRow]
  
  var body: some View {
    VStack {
      Text(categoryName).tracking(1).font(AspireFonts.rubikRegular(size: 20)).padding(.vertical).foregroundColor(.white)
      HStack {
        VStack {
          GradientTextView(string: totals.budgetedTotal.stringValue, tracking: 1.35, font: AspireFonts.rubikMedium(size: 18), paddingEdges: .horizontal, paddingLength: nil, gradient: Colors.yellowGradient)
          
          Text("Budgeted").tracking(0.5).font(AspireFonts.rubikLight(size: 7.5)).padding(.top, 2).foregroundColor(.white).opacity(0.6)
        }
        VStack {
          GradientTextView(string: totals.availableTotal.stringValue, tracking: 1.35, font: AspireFonts.rubikMedium(size: 18), paddingEdges: .horizontal, paddingLength: nil, gradient: Colors.greenGradient)
          
          Text("Available").tracking(0.5).font(AspireFonts.rubikLight(size: 7.5)).padding(.top, 2).foregroundColor(.white).opacity(0.6)
        }
        VStack {
          GradientTextView(string: totals.spentTotals.stringValue, tracking: 1.35, font: AspireFonts.rubikMedium(size: 18), paddingEdges: .horizontal, paddingLength: nil, gradient: Colors.redGradient)
          
          Text("Spent").tracking(0.5).font(AspireFonts.rubikLight(size: 7.5)).padding(.top, 2).foregroundColor(.white).opacity(0.6)
        }
      }
      Divider().padding(.horizontal)
      
      ForEach(self.categoryRows, id: \.self) { row in
        VStack {
          DashboardRow(categoryRow: row).padding().transition(.identity)
          Divider().padding(.horizontal)
        }
      }
    }
  }
}

//struct ExpandedCardView_Previews: PreviewProvider {
//    static var previews: some View {
//        ExpandedCardView()
//    }
//}

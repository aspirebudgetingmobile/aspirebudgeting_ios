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
      Text(categoryRow.categoryName)
        .tracking(1)
        .font(.rubikRegular(size: 18))
        .padding([.horizontal])
        .padding(.bottom, 5)
        .foregroundColor(.white)
      HStack {
        VStack {
          GradientTextView(
            string: categoryRow.budgeted,
            tracking: 1,
            font: .rubikRegular(size: 16),
            paddingEdges: .horizontal,
            paddingLength: nil,
            gradient: Colors.yellowGradient
          )

          GradientTextView(
            string: "Budgeted",
            tracking: 1,
            font: .rubikLight(size: 12),
            paddingEdges: .horizontal,
            paddingLength: nil,
            gradient: Colors.yellowGradient
          )
        }
        Spacer()
        VStack {
          GradientTextView(
            string: categoryRow.available,
            tracking: 1,
            font: .rubikRegular(size: 16),
            paddingEdges: .horizontal,
            paddingLength: nil,
            gradient: Colors.greenGradient
          )

          GradientTextView(
            string: "Available",
            tracking: 1,
            font: .rubikLight(size: 12),
            paddingEdges: .horizontal,
            paddingLength: nil,
            gradient: Colors.greenGradient
          )
        }
        Spacer()
        VStack {
          GradientTextView(
            string: categoryRow.spent,
            tracking: 1,
            font: .rubikRegular(size: 16),
            paddingEdges: .horizontal,
            paddingLength: nil,
            gradient: Colors.redGradient
          )
          GradientTextView(
            string: "Spent",
            tracking: 1,
            font: .rubikLight(size: 12),
            paddingEdges: .horizontal,
            paddingLength: nil,
            gradient: Colors.redGradient
          )
        }
      }
    }
  }
}

// struct DashboardRow_Previews: PreviewProvider {
//    static var previews: some View {
//        DashboardRow()
//    }
// }

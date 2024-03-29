//
//  DashboardRow.swift
//  Aspire Budgeting
//

import SwiftUI

#warning("Remove DashboardRow")
struct DashboardRow: View {
  var categoryRow: DashboardCategory

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
            string: categoryRow.budgeted.stringValue,
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
            string: categoryRow.available.stringValue,
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
            string: categoryRow.spent.stringValue,
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

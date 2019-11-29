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
      Text(categoryName).tracking(1).font(.custom("Rubik-Regular", size: 20)).padding(.vertical).foregroundColor(.white)
      HStack {
        VStack {
          Text(totals.budgetedTotal.stringValue).tracking(1.35).font(.custom("Rubik-Medium", size: 18)).padding([.horizontal]).foregroundColor(.clear).overlay(Colors.yellowGradient.mask(Text(totals.budgetedTotal.stringValue).tracking(1.35).font(.custom("Rubik-Medium", size: 18)).scaledToFill()))
          Text("Budgeted").tracking(0.5).font(.custom("Rubik-Light", size: 7.5)).padding(.top, 2).foregroundColor(.white).opacity(0.6)
        }
        VStack {
          Text(totals.availableTotal.stringValue).tracking(1.35).font(.custom("Rubik-Medium", size: 18)).padding([.horizontal]).foregroundColor(.clear).overlay(Colors.greenGradient.mask(Text(totals.availableTotal.stringValue).tracking(1.35).font(.custom("Rubik-Medium", size: 18)).scaledToFill()))
          Text("Available").tracking(0.5).font(.custom("Rubik-Light", size: 7.5)).padding(.top, 2).foregroundColor(.white).opacity(0.6)
        }
        VStack {
          Text(totals.spentTotals.stringValue).tracking(1.35).font(.custom("Rubik-Medium", size: 18)).padding([.horizontal]).foregroundColor(.clear).overlay(Colors.redGradient.mask(Text(totals.spentTotals.stringValue).tracking(1.35).font(.custom("Rubik-Medium", size: 18)).scaledToFill()))
          Text("Spent").tracking(0.5).font(.custom("Rubik-Light", size: 7.5)).padding(.top, 2).foregroundColor(.white).opacity(0.6)
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

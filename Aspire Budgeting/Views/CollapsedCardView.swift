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
  let categoryRows: [DashboardCategoryRow]
  
  func getGradient(for number: AspireNumber) -> LinearGradient {
    if number.isNegative {
      return Colors.redGradient
    }
    
    return Colors.greenGradient
  }
  
  var body: some View {
    HStack {
      VStack(alignment: .leading) {
        Text(categoryName).tracking(1).font(.custom("Rubik-Regular", size: 20)).padding([.top]).foregroundColor(.white)
        Text("Budgeted").tracking(1).font(.custom("Rubik-Light", size: 13)).padding([.top]).foregroundColor(.white)
        Text(totals.budgetedTotal.stringValue).tracking(1.18).font(.custom("Rubik-Medium", size: 15)).padding([.top], 5).padding([.bottom]).foregroundColor(.clear).overlay(Colors.redGradient.mask(Text(totals.budgetedTotal.stringValue).tracking(1.18).font(.custom("Rubik-Medium", size: 15)).scaledToFill()))
      }.padding([.horizontal])
      
      Spacer()
      
      VStack {
        Text(totals.availableTotal.stringValue)
          .tracking(2.34)
          .font(.custom("Rubik-Medium", size: 30))
          .foregroundColor(.clear)
          .padding([.trailing])
          .overlay(self.getGradient(for: totals.availableTotal)
            .mask(Text(totals.availableTotal.stringValue)
              .tracking(2.34)
              .font(.custom("Rubik-Medium", size: 30))
              .scaledToFill()))
        Text("Available").tracking(1).font(.custom("Rubik-Light", size: 13)).foregroundColor(.white)
      }
    }
  }
}

//struct CollapsedCardView_Previews: PreviewProvider {
//  static var previews: some View {
//    CollapsedCardView()
//  }
//}

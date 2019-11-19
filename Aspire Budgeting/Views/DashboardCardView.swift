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
    var availableTotal: String
    var budgetedTotal: String
  }
  
  let categoryName: String
  let totals: Totals
  
  var body: some View {
    HStack {
      VStack(alignment: .leading) {
        Text(categoryName).font(.title).padding([.top])
        Text("Budgeted").font(.caption).padding([.top])
        Text(totals.budgetedTotal).font(.headline).padding([.top], 5).padding([.bottom])
      }.padding([.horizontal])
      
      Spacer()
      
      VStack {
        Text(totals.availableTotal).font(.largeTitle).foregroundColor(.clear).padding([.trailing]).overlay(Colors.greenGradient.mask(Text(totals.availableTotal).font(.largeTitle).scaledToFill()))
        Text("Available").font(.caption)
      }
    }.background(Color.gray.opacity(0.2))
      .cornerRadius(10)
      .shadow(radius: 5)
      .padding()
  }
}

//struct DashboardCardVIew_Previews: PreviewProvider {
//    static var previews: some View {
//        DashboardCardVIew()
//    }
//}

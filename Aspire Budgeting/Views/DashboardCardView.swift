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
        Text(categoryName).font(.custom("Rubik-Regular", size: 20)).padding([.top]).foregroundColor(.white)
        Text("Budgeted").font(.custom("Rubik-Light", size: 13)).padding([.top]).foregroundColor(.white)
        Text(totals.budgetedTotal).font(.custom("Rubik-Medium", size: 15)).padding([.top], 5).padding([.bottom]).foregroundColor(.white)
      }.padding([.horizontal])
      
      Spacer()
      
      VStack {
        Text(totals.availableTotal).font(.largeTitle).foregroundColor(.clear).padding([.trailing]).overlay(Colors.greenGradient.mask(Text(totals.availableTotal).font(.custom("Rubik-Medium", size: 30)).scaledToFill()))
        Text("Available").font(.custom("Rubik-Light", size: 13)).foregroundColor(.white)
      }
    }.background(Color.white.opacity(0.07))
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

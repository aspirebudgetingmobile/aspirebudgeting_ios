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
      Text(categoryRow.categoryName).tracking(1).font(.custom("Rubik-Regular", size: 18)).padding([.horizontal]).padding(.bottom, 5).foregroundColor(.white)
      
      HStack {
        VStack {
          Text(categoryRow.budgeted).tracking(1).font(.custom("Rubik-Regular", size: 16)).padding([.horizontal]).foregroundColor(.clear).overlay(Colors.redGradient.mask(Text(categoryRow.budgeted).tracking(1).font(.custom("Rubik-Regular", size: 16)).scaledToFill()))
          
          Text("Budgeted").tracking(1).font(.custom("Rubik-Light", size: 12)).padding([.horizontal]).foregroundColor(.clear).overlay(Colors.redGradient.mask(Text("Budgeted").tracking(1).font(.custom("Rubik-Light", size: 12)).scaledToFill()))
        }
        Spacer()
        VStack {
          Text(categoryRow.available).tracking(1).font(.custom("Rubik-Regular", size: 16)).padding([.horizontal]).foregroundColor(.clear).overlay(Colors.greenGradient.mask(Text(categoryRow.available).tracking(1).font(.custom("Rubik-Regular", size: 16)).scaledToFill()))
          
          Text("Available").tracking(1).font(.custom("Rubik-Light", size: 12)).padding([.horizontal]).foregroundColor(.clear).overlay(Colors.greenGradient.mask(Text("Available").tracking(1).font(.custom("Rubik-Light", size: 12)).scaledToFill()))
        }
        Spacer()
        VStack {
          Text(categoryRow.spent).tracking(1).font(.custom("Rubik-Regular", size: 16)).padding([.horizontal]).foregroundColor(.clear).overlay(Colors.redGradient.mask(Text(categoryRow.spent).tracking(1).font(.custom("Rubik-Regular", size: 16)).scaledToFill()))
          
          Text("Spent").tracking(1).font(.custom("Rubik-Light", size: 12)).padding([.horizontal]).foregroundColor(.clear).overlay(Colors.redGradient.mask(Text("Spent").tracking(1).font(.custom("Rubik-Light", size: 12)).scaledToFill()))
        }
      }
    }
  }
}

//struct DashboardRow_Previews: PreviewProvider {
//    static var previews: some View {
//        DashboardRow()
//    }
//}

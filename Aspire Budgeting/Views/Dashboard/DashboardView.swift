//
//  DashboardView.swift
//  Aspire Budgeting
//
//  Created by TeraMo Labs on 10/30/19.
//  Copyright © 2019 TeraMo Labs. All rights reserved.
//

import SwiftUI

struct DashboardView: View {
  @EnvironmentObject var sheetsManager: GoogleSheetsManager
  
  let file: File
  
  func availableTotals(for group: String) -> DashboardCardView.Totals {
    let index = getIndex(for: group)
    let availableTotal = self.sheetsManager.dashboardMetadata!.groupedAvailableTotals[index]
    let budgetedTotal = self.sheetsManager.dashboardMetadata!.groupedBudgetedTotals[index]
    let spentTotal = self.sheetsManager.dashboardMetadata!.groupedSpentTotals[index]
    return DashboardCardView.Totals(availableTotal: availableTotal, budgetedTotal: budgetedTotal, spentTotals: spentTotal)
  }
  
  func getIndex(for group: String) -> Int {
    return self.sheetsManager.dashboardMetadata!.groups.firstIndex(of: group)!
  }
  
  var body: some View {
    VStack {
      if self.sheetsManager.error == nil {
        if self.sheetsManager.dashboardMetadata?.groups != nil {
          List {
            ForEach(self.sheetsManager.dashboardMetadata!.groups, id: \.self) { group in
              DashboardCardView(categoryName: group, totals: self.availableTotals(for: group), categoryRows: self.sheetsManager.dashboardMetadata!.groupedCategoryRows[self.getIndex(for: group)])
            }
          }
        } else {
          ZStack {
            Rectangle().foregroundColor(Colors.aspireGray).edgesIgnoringSafeArea(.all)
            Text("Fetching data...").font(.custom("Rubik-Light", size: 18)).foregroundColor(.white).opacity(0.6)
          }
        }
      } else {
        ZStack {
          Rectangle().foregroundColor(Colors.aspireGray).edgesIgnoringSafeArea(.all)
          ErrorBannerView(error: self.sheetsManager.error!)
        }
      }
    }.navigationBarHidden(true)
      .navigationBarBackButtonHidden(true)
      .background(Colors.aspireGray)
      .edgesIgnoringSafeArea(.all).onAppear {

      self.sheetsManager.verifySheet(spreadsheet: self.file)
      self.sheetsManager.fetchCategoriesAndGroups(spreadsheet: self.file)
    }
  }
}

//struct DashboardView_Previews: PreviewProvider {
//    static var previews: some View {
//        DashboardView()
//    }
//}

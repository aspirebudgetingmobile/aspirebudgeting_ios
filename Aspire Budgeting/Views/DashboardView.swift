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
    let index = self.sheetsManager.dashboardMetadata!.groups.firstIndex(of: group)
    let availableTotal = self.sheetsManager.dashboardMetadata!.groupedAvailableTotals[index!]
    let budgetedTotal = self.sheetsManager.dashboardMetadata!.groupedBudgetedTotals[index!]
    return DashboardCardView.Totals(availableTotal: availableTotal, budgetedTotal: budgetedTotal)
  }
  
  var body: some View {
    VStack {
      if self.sheetsManager.error == nil {
        if self.sheetsManager.dashboardMetadata?.groups != nil {
          List {
            ForEach(self.sheetsManager.dashboardMetadata!.groups, id: \.self) { group in
              DashboardCardView(categoryName: group, totals: self.availableTotals(for: group))
            }
          }
        } else {
          Text("Fetching data")
        }
      } else {
        ErrorBannerView(error: self.sheetsManager.error!)
      }
    }.navigationBarTitle("Dashboard").background(Colors.aspireGray).edgesIgnoringSafeArea(.all).onAppear {

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

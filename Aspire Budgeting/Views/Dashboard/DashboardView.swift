//
//  DashboardView.swift
//  Aspire Budgeting
//
//  Created by TeraMo Labs on 10/30/19.
//  Copyright © 2019 TeraMo Labs. All rights reserved.
//

import SwiftUI

struct DashboardView: View {

  let viewModel: DashboardViewModel
//  @EnvironmentObject var sheetsManager: GoogleSheetsManager

//  let file: Fileself.currentState = currentState

  private func availableTotals(for group: String) -> DashboardCardView.Totals {
    let index = getIndex(for: group)
    let availableTotal = viewModel.metadata!.groupedAvailableTotals[index]
    let budgetedTotal = viewModel.metadata!.groupedBudgetedTotals[index]
    let spentTotal = viewModel.metadata!.groupedSpentTotals[index]
    return DashboardCardView.Totals(
      availableTotal: availableTotal,
      budgetedTotal: budgetedTotal,
      spentTotals: spentTotal
    )
  }

  private func getIndex(for group: String) -> Int {
    return viewModel.metadata!.groups.firstIndex(of: group)!
  }

  private func categoryRows(for group: String) -> [DashboardCategoryRow] {
    return viewModel.metadata!.groupedCategoryRows[getIndex(for: group)]
  }

//  private func verifySheet() {
//    sheetsManager.verifySheet(spreadsheet: self.file)
//  }

  var body: some View {
    VStack {
      if viewModel.error == nil {
        if viewModel.metadata?.groups != nil {
          List {
            ForEach(viewModel.metadata!.groups, id: \.self) { group in
              DashboardCardView(
                categoryName: group,
                totals: self.availableTotals(for: group),
                categoryRows: self.categoryRows(for: group)
              ).background(Colors.aspireGray)
            }
          }
        } else {
          LoadingView()
//          ZStack {
//            Rectangle().foregroundColor(Colors.aspireGray)
//              .edgesIgnoringSafeArea(.all)
//            Text("Fetching data...")
//              .font(.custom("Rubik-Light", size: 18))
//              .foregroundColor(.white)
//              .opacity(0.6)
//          }
        }
      } else {
        ZStack {
          Rectangle().foregroundColor(Colors.aspireGray).edgesIgnoringSafeArea(.all)
          ErrorBannerView(error: viewModel.error!)
        }
      }
    }.navigationBarHidden(true)
      .navigationBarBackButtonHidden(true)
      .background(Colors.aspireGray)
      .edgesIgnoringSafeArea(.all)
      .onAppear {
//        self.verifySheet()
      }
  }
}

// struct DashboardView_Previews: PreviewProvider {
//    static var previews: some View {
//        DashboardView()
//    }
// }

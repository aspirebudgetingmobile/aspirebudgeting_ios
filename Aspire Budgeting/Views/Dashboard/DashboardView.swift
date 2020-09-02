//
//  DashboardView.swift
//  Aspire Budgeting
//

import SwiftUI

struct DashboardView: View {

  let viewModel: DashboardViewModel

  var body: some View {
    VStack {
      if viewModel.error == nil {
        if viewModel.metadata?.groups != nil {
          List {
            ForEach(viewModel.metadata!.groups, id: \.self) { group in
              DashboardCardView(
                categoryName: group,
                totals: self.viewModel.availableTotals(for: group),
                categoryRows: self.viewModel.categoryRows(for: group)
              ).background(Colors.aspireGray)
            }
          }
        } else {
          LoadingView()
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
        self.viewModel.refresh()
      }
  }
}

// struct DashboardView_Previews: PreviewProvider {
//    static var previews: some View {
//        DashboardView()
//    }
// }

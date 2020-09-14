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
          CardListView(cardViewItems: viewModel.cardViewItems)
        } else {
          GeometryReader { geo in
            LoadingView(height: geo.frame(in: .local).size.height)
          }
        }
      } else {
        ZStack {
          Rectangle().foregroundColor(Colors.aspireGray).edgesIgnoringSafeArea(.all)
          ErrorBannerView(error: viewModel.error!)
        }
      }
    }.navigationBarHidden(false)
      .navigationBarBackButtonHidden(true)
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

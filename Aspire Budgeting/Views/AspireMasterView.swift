//
//  AspireMasterView.swift
//  Aspire Budgeting
//

import SwiftUI

struct AspireMasterView: View {
  //TODO: Remove GoogleSheetsManager
  @EnvironmentObject var sheetsManager: GoogleSheetsManager
  @EnvironmentObject var appCoordinator: AppCoordinator

  @State private var selectedSegment = 0
  var body: some View {
    VStack {
      AspireNavigationBar()
        .edgesIgnoringSafeArea(.all)
        .frame(maxHeight: 65)
      AspireSegmentedView(selectedSegment: $selectedSegment)
      if selectedSegment == 0 {
        DashboardView(viewModel: appCoordinator.dashboardVM)
      } else if selectedSegment == 1 {
        AccountBalancesView()
      }
    }
  }
}

struct AspireMasterView_Previews: PreviewProvider {
  static var previews: some View {
    AspireMasterView()
  }
}

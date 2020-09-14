//
//  AspireMasterView.swift
//  Aspire Budgeting
//

import SwiftUI

struct AspireMasterView: View {
  @EnvironmentObject var appCoordinator: AppCoordinator

  let tabBarItems = [TabBarItem(imageName: "rectangle.grid.1x2", title: "Dashboard"),
                     TabBarItem(imageName: "creditcard", title: "Accounts"),
                     TabBarItem(imageName: "arrow.up.arrow.down", title: "Transactions"),
                     TabBarItem(imageName: "gear", title: "Settings"),
                     ]

  @State private var selectedTab = 0
  @State private var navTitle: String = ""

  var body: some View {
    VStack {
      AspireNavigationBar(title: $navTitle)
        .frame(maxHeight: 65)
      Group {
        if selectedTab == 0 {
          DashboardView(viewModel: appCoordinator.dashboardVM)
            .onAppear {
              self.navTitle = "Dashboard"
            }
        } else if selectedTab == 1 {
          AccountBalancesView()
            .onAppear {
              self.navTitle = "Accounts"
            }
        }
      }
      .frame(height: UIScreen.main.bounds.height - 250)

      TabBarView(selectedTab: $selectedTab,
                 tabBarItems: tabBarItems,
                 prominentItemImageName: "plus") {
                  print("Hoogah boogah")
      }
      .frame(height: 95)
      .padding(.horizontal, 5)
      .background(Color.primaryBackgroundColor)
    }
  }
}

struct AspireMasterView_Previews: PreviewProvider {
  static var previews: some View {
    AspireMasterView()
  }
}

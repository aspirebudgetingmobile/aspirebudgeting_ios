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
  @State private var addingTransaction = false

  var body: some View {
    GeometryReader { _ in
      VStack {
        AspireNavigationBar(title: $navTitle)
          .edgesIgnoringSafeArea(.all)
          .frame(height: 50)
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
        .frame(height: UIScreen.main.bounds.height - 200)

        TabBarView(selectedTab: $selectedTab,
                   tabBarItems: tabBarItems,
                   prominentItemImageName: "plus") {
          self.addingTransaction.toggle()
        }
        .frame(height: 95)
        .padding(.horizontal, 5)
        .background(Color.primaryBackgroundColor)
        .sheet(isPresented: $addingTransaction) {
          AddTransactionView()
        }
      }
    }
  }
}

struct AspireMasterView_Previews: PreviewProvider {
  static var previews: some View {
    AspireMasterView()
  }
}

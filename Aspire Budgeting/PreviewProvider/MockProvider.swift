//
//  MockProvider.swift
//  Aspire Budgeting
//

import Foundation

enum MockProvider {
  static var tabBarItems: [TabBarItem] {
    var tabBarItems = [TabBarItem]()
    tabBarItems.append(TabBarItem(imageName: "rectangle.grid.1x2", title: "Dashboard"))
    tabBarItems.append(TabBarItem(imageName: "creditcard", title: "Accounts"))
    tabBarItems.append(TabBarItem(imageName: "arrow.up.arrow.down", title: "Transactions"))
    tabBarItems.append(TabBarItem(imageName: "gear", title: "Settings"))
    return tabBarItems
  }
// swiftlint:disable line_length
//  static var cardViewItems: [CardView.CardViewItem] {
//    var cardViewItems = [CardView.CardViewItem]()
//    cardViewItems.append(.init(title: "Credit Card Payments",
//  lowerBound: "$0",
//  upperBound: "$1000",
//  progressFactor: 0.25))
//    cardViewItems.append(.init(title: "Fixed Expenses", lowerBound: "$0", upperBound: "$2500", progressFactor: 0.5))
//    cardViewItems.append(.init(title: "Savings", lowerBound: "$0", upperBound: "$10000", progressFactor: 0.7))
//    
//    return cardViewItems
//  }
// swiftlint:enable line_length
}

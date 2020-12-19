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

  static var cardViewItems: [BaseCardView<DashboardCardView>.CardViewItem] {
    var cardViewItems = [BaseCardView<DashboardCardView>.CardViewItem]()
    cardViewItems.append(.init(title: "Credit Card Payments",
                               availableTotal: AspireNumber(stringValue: "$0"),
                               budgetedTotal: AspireNumber(stringValue: "$1000"),
                               spentTotal: AspireNumber(stringValue: "$50"),
                               progressFactor: 0.25,
                               categories: [
                                Category(row: ["",
                                               "",
                                               "Dummy Category",
                                               "$30",
                                               "b",
                                               "c",
                                               "20",
                                               "e",
                                               "f",
                                               "15",
                                ]),
                               ]))

    cardViewItems.append(.init(title: "Fixed Expenses",
                               availableTotal: AspireNumber(stringValue: "$0"),
                               budgetedTotal: AspireNumber(stringValue: "$2500"),
                               spentTotal: AspireNumber(stringValue: "$50"),
                               progressFactor: 0.5,
                               categories: [
                                Category(row: ["", "", "", "", "", "", "", "", "", ""]), ]))

    cardViewItems.append(.init(title: "Savings",
                               availableTotal: AspireNumber(stringValue: "$0"),
                               budgetedTotal: AspireNumber(stringValue: "$10000"),
                               spentTotal: AspireNumber(stringValue: "$50"),
                               progressFactor: 0.7,
                               categories: [
                                Category(row: ["", "", "", "", "", "", "", "", "", ""]), ]))

    return cardViewItems
  }
}

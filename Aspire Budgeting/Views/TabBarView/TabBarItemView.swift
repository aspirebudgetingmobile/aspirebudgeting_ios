//
//  TabBarItemView.swift
//  Aspire Budgeting
//

import SwiftUI

struct TabBarItem {
  let imageName: String
  let title: String
}

struct TabBarItemView: View {
  let tabBarItem: TabBarItem
  
  let selectedIndex: Int
  let tabBarIndex: Int
  
  let defaultColor: Color
  let selectedColor: Color
  
  let font : Font
  
  private var displayColor: Color {
    selected ? selectedColor : defaultColor
  }
  
  private var selected: Bool {
    selectedIndex == tabBarIndex
  }
  
  var body: some View {
    VStack {
      Image(systemName: tabBarItem.imageName)
        .resizable()
        .foregroundColor(displayColor)
        .aspectRatio(contentMode: .fit)
        .frame(width: 30, height: 30)
      Text(tabBarItem.title)
        .font(font)
        .foregroundColor(displayColor)
        .frame(height: 10)
    }
  }
}

struct TabBarItemView_Previews: PreviewProvider {
    static var previews: some View {
      Group {
        TabBarItemView(tabBarItem: MockProvider.tabBarItems[0],
                       selectedIndex: 0,
                       tabBarIndex: 0,
                       defaultColor: .tabBarItemDefaultTintColor,
                       selectedColor: .tabBarItemSelectedTintColor,
                       font: .nunitoBold(size: 14))
        TabBarItemView(tabBarItem: MockProvider.tabBarItems[1],
                       selectedIndex: 0,
                       tabBarIndex: 1,
                       defaultColor: .tabBarItemDefaultTintColor,
                       selectedColor: .tabBarItemSelectedTintColor,
                       font: .nunitoBold(size: 14))
        TabBarItemView(tabBarItem: MockProvider.tabBarItems[0],
                       selectedIndex: 0,
                       tabBarIndex: 1,
                       defaultColor:.tabBarItemDefaultTintColor,
                       selectedColor: .tabBarItemSelectedTintColor,
                       font: .nunitoBold(size: 14))
          .environment(\.colorScheme, .dark)
      }
      
    }
}

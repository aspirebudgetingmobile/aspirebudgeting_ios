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
  
  func categoryRows(for group: String) -> [DashboardCategoryRow] {
    let index = self.sheetsManager.groupsAndCategories!.groups.firstIndex(of: group)
    return self.sheetsManager.groupsAndCategories!.groupedCategoryRows[index!]
  }
    var body: some View {
      VStack {
        if self.sheetsManager.error == nil {
          if self.sheetsManager.groupsAndCategories?.groups != nil {
            List {
              ForEach(self.sheetsManager.groupsAndCategories!.groups, id: \.self) { group in
                Section(header: Text(group)) {
                  ForEach(self.categoryRows(for: group), id: \.self) { row in
                    DashboardRow(categoryRow: row)
                  }
                }
              }
            }.listStyle(GroupedListStyle())
          } else {
            Text("Fetching data")
          }
        } else {
          ErrorBannerView(error: self.sheetsManager.error!)
        }
        
      }.onAppear {
          self.sheetsManager.verifySheet(spreadsheet: self.file)
        self.sheetsManager.fetchCategoriesAndGroups(spreadsheet: self.file)
      }.navigationBarTitle("Dashboard")
  }
}

//struct DashboardView_Previews: PreviewProvider {
//    static var previews: some View {
//        DashboardView()
//    }
//}

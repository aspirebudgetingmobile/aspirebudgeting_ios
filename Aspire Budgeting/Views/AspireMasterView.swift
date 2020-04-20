//
//  AspireMasterView.swift
//  Aspire Budgeting
//
//  Created by TeraMo Labs on 12/7/19.
//  Copyright © 2019 TeraMo Labs. All rights reserved.
//

import SwiftUI

struct AspireMasterView: View {
  @EnvironmentObject var sheetsManager: GoogleSheetsManager
  
  @State private var selectedSegment = 0
    var body: some View {
      VStack {
        AspireNavigationBar().edgesIgnoringSafeArea(.all).frame(maxHeight: 65)
        AspireSegmentedView(selectedSegment: $selectedSegment)
        if selectedSegment == 0 {
          DashboardView(file: sheetsManager.defaultFile!)
        }
//        else if selectedSegment == 1 {
//          AddTransactionView()
//        }
          else if selectedSegment == 1 {
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

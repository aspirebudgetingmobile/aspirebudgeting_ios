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
    var body: some View {
      VStack {
        AspireNavigationBar().edgesIgnoringSafeArea(.all).frame(maxHeight: 65)
        AspireSegmentedView()
        DashboardView(file: sheetsManager.defaultFile!)
      }
        
    }
}

struct AspireMasterView_Previews: PreviewProvider {
    static var previews: some View {
        AspireMasterView()
    }
}

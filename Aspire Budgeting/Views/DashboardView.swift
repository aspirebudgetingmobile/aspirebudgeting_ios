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
  
//  @State var fetchedData = true
  let file: File
    var body: some View {
      VStack {
        if self.sheetsManager.error == nil {
          Text(file.name)
        } else {
          Text("Could not fetch data")
        }
        
      }.onAppear {
          self.sheetsManager.verifySheet(spreadsheet: self.file)
      }
  }
}

//struct DashboardView_Previews: PreviewProvider {
//    static var previews: some View {
//        DashboardView()
//    }
//}

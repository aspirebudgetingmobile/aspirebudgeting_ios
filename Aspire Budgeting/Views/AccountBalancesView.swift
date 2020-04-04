//
//  AccountBalancesView.swift
//  Aspire Budgeting
//
//  Created by TeraMo Labs on 4/4/20.
//  Copyright © 2020 TeraMo Labs. All rights reserved.
//

import SwiftUI

struct AccountBalancesView: View {
  @EnvironmentObject var sheetsManager: GoogleSheetsManager
    var body: some View {
      ZStack {
        Rectangle().foregroundColor(Colors.aspireGray).edgesIgnoringSafeArea(.all)
      }
  }
}

struct AccountBalancesView_Previews: PreviewProvider {
    static var previews: some View {
        AccountBalancesView()
    }
}

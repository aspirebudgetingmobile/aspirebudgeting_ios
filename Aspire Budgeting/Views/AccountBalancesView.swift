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
      
      if self.sheetsManager.error == nil {
        if self.sheetsManager.accountBalancesMetadata?.accountBalances != nil {
          List {
            ForEach(self.sheetsManager.accountBalancesMetadata!.accountBalances, id: \.self) { accountBalance in
              Text(accountBalance.accountName + " " + accountBalance.balance).foregroundColor(.white)
            }
          }
        } else {
          ZStack {
            Rectangle().foregroundColor(Colors.aspireGray).edgesIgnoringSafeArea(.all)
            Text("Fetching data...").font(.custom("Rubik-Light", size: 18)).foregroundColor(.white).opacity(0.6)
          }
        }
        
      } else {
        ZStack {
          Rectangle().foregroundColor(Colors.aspireGray).edgesIgnoringSafeArea(.all)
          ErrorBannerView(error: self.sheetsManager.error!)
        }
      }
    }
  }
}

struct AccountBalancesView_Previews: PreviewProvider {
  static var previews: some View {
    AccountBalancesView()
  }
}

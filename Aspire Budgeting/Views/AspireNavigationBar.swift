//
//  AspireNavigationBar.swift
//  Aspire Budgeting
//
//  Created by TeraMo Labs on 11/18/19.
//  Copyright © 2019 TeraMo Labs. All rights reserved.
//

import GoogleSignIn
import SwiftUI

struct AspireNavigationBar: View {
  @EnvironmentObject var userManager: UserManager<GIDGoogleUser>
  @EnvironmentObject var sheetsManager: GoogleSheetsManager

  @State var showSettings = false
  @State var showAddTransactions = false

  let versionBuild = "Version: " + AspireVersionInfo.version + "; Build: " + AspireVersionInfo.build
  var body: some View {
    ZStack {
      Colors.aspireGray
      VStack {
        Spacer()
        HStack {
          Image("logo")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(maxHeight: 60)
          Text("Aspire")
            .font(.custom("Nunito-Regular", size: 30))
            .foregroundColor(.white)
        }
      }.padding(.bottom, 5)
      VStack {
        Spacer()
        HStack {
          Spacer()
          Button(
            action: {
              self.showAddTransactions = true
            },
            label: {
              Image(systemName: "plus")
                .padding()
                .foregroundColor(.white)
            }
          )
          .sheet(isPresented: $showAddTransactions) {
            AddTransactionView().environmentObject(self.sheetsManager)
          }

          Button(
            action: {
              print("Settings")
              self.showSettings = true
            },
            label: {
              Image(systemName: "gear").padding().foregroundColor(.white)
            }
          )
          .padding([.top, .bottom], 10)
          .actionSheet(isPresented: $showSettings) {
            ActionSheet(
              title: Text("Aspire Budgeting"),
              message: Text(self.versionBuild),
              buttons: [
                ActionSheet.Button.default(Text("Sign Out")) {
                  self.userManager.signOut()
                },
                ActionSheet.Button.cancel(),
              ]
            )
          }
        }
      }
    }
  }
}

struct AspireNavigationBar_Previews: PreviewProvider {
  static var previews: some View {
    AspireNavigationBar()
  }
}

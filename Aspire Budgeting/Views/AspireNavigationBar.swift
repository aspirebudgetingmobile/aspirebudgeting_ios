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
  @State var showSettings = false
  
  let versionBuild = "Version: " + AspireVersionInfo.version + "; Build: " + AspireVersionInfo.build
  var body: some View {
//    VStack {
      ZStack {
        Colors.aspireGray
        VStack {
          Spacer()
          HStack {
            Image("logo").resizable().aspectRatio(contentMode: .fit).frame(maxHeight: 60)
            Text("Aspire").font(.custom("Nunito-Regular", size: 30)).foregroundColor(.white)
          }
        }.padding(.bottom, 5)
        VStack {
          Spacer()
          HStack {
            Spacer()
            Button(action: {
              print("Settings")
              self.showSettings = true
            }) {
              Image(systemName: "gear").padding().foregroundColor(.white)
            }.padding([.top, .bottom], 10)
              .actionSheet(isPresented: $showSettings) {
//                SettingsView().environmentObject(self.userManager)
                ActionSheet(title: Text("Aspire Budgeting"),
                            message: Text(self.versionBuild),
                            buttons: [ActionSheet.Button.default(Text("Sign Out"), action: {
                              self.userManager.signOut()
                            }), ActionSheet.Button.cancel()])
            }
          }
        }
      }
//    }
  }
}

struct AspireNavigationBar_Previews: PreviewProvider {
  static var previews: some View {
    AspireNavigationBar()
  }
}

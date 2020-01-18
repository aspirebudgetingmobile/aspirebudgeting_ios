//
//  SettingsView.swift
//  Aspire Budgeting
//
//  Created by TeraMo Labs on 1/18/20.
//  Copyright © 2020 TeraMo Labs. All rights reserved.
//

import GoogleSignIn
import SwiftUI

struct SettingsView: View {
  @EnvironmentObject var userManager: UserManager<GIDGoogleUser>
    var body: some View {
      Button(action: {
        self.userManager.signOut()
      }) {
        Text("Sign Out")
      }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

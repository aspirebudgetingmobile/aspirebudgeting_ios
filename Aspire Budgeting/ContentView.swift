//
//  ContentView.swift
//  Aspire Budgeting
//
//

import SwiftUI

struct ContentView: View {
  @ObservedObject var userManager: UserManager
  
    var body: some View {
      VStack {
        if userManager.user == nil {
          SignInView()
        } else {
          Button("Sign Out") {
            self.userManager.signOut()
          }
        }
      }
      
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(userManager: UserManager())
    }
}

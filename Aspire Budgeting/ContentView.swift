//
//  ContentView.swift
//  Aspire Budgeting
//
//

import SwiftUI

struct ContentView: View {
  @ObservedObject var userManager: UserManager
  let driveManager = GoogleDriveManager()
  
    var body: some View {
      VStack {
        if userManager.user == nil {
          SignInView()
        } else {
          VStack {
            Button("Sign Out") {
              self.userManager.signOut()
            }
            
            Button("Get List") {
              
              self.driveManager.getFileList(user: self.userManager.user!.googleUser)
            }
          }
        }
      }
      
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView(userManager: UserManager())
//    }
//}

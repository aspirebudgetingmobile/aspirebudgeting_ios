//
//  ContentView.swift
//  Aspire Budgeting
//
//

import SwiftUI

struct ContentView: View {
  @ObservedObject var userManager: UserManager
  @ObservedObject var driveManager: GoogleDriveManager
  
    var body: some View {
      VStack {
        if userManager.user == nil {
          SignInView()
        } else {
          VStack {
            Button("Sign Out") {
              self.userManager.signOut()
            }
            
            List(self.driveManager.fileList) { file in
              Text(file.name)
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
//      ContentView(userManager: ObjectFactory().userManager)
//    }
//}

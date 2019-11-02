//
//  FileSelectorView.swift
//  Aspire Budgeting
//
//  Created by TeraMo Labs on 10/29/19.
//  Copyright © 2019 TeraMo Labs. All rights reserved.
//

import SwiftUI

struct FileSelectorView: View {
  @EnvironmentObject var userManager: UserManager
  @EnvironmentObject var driveManager: GoogleDriveManager
  @EnvironmentObject var sheetsManager: GoogleSheetsManager
  
  var body: some View {
    ZStack {
      if self.userManager.user != nil {
        NavigationView {
          List(self.driveManager.fileList) { file in
            NavigationLink(destination: DashboardView(file: file)) {
              Text(file.name)
            }
          }
          .navigationBarTitle("Welcome, \(self.userManager.user!.name)")
          .navigationBarItems(leading: Button("Sign Out") {
            self.userManager.signOut()
            self.driveManager.clearFileList()
            }, trailing: Button("Get List") {
              
          })
        }.onAppear {
          if self.driveManager.fileList.isEmpty {
            self.driveManager.getFileList()
          }
        }
      }
      
      if self.driveManager.error != nil {
        Text("Error occured")
      }
    }
  }
}

//struct FileSelectorView_Previews: PreviewProvider {
//    static var previews: some View {
//        FileSelectorView()
//    }
//}

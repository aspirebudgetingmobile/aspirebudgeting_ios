//
//  FileSelectorView.swift
//  Aspire Budgeting
//
//  Created by TeraMo Labs on 10/29/19.
//  Copyright © 2019 TeraMo Labs. All rights reserved.
//

import GoogleSignIn
import SwiftUI

struct FileSelectorView: View {
  @EnvironmentObject var userManager: UserManager<GIDGoogleUser>
  @EnvironmentObject var driveManager: GoogleDriveManager
  @EnvironmentObject var sheetsManager: GoogleSheetsManager
  
  @State var selectedFile: File?
  
  var body: some View {
    ZStack {
      if self.userManager.user != nil {
        ZStack {
          if self.selectedFile == nil {
            NavigationView {
              List(self.driveManager.fileList) { file in
                Button(action: {
                  self.sheetsManager.defaultFile = file
                  self.selectedFile = file
                }) {
                  Text(file.name)
                }
              }
              .navigationBarTitle("Link your Aspire sheet")
            }.onAppear {
              if self.driveManager.fileList.isEmpty {
                self.driveManager.getFileList()
              }
            }
          }
          if self.selectedFile != nil {
            AspireMasterView()
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

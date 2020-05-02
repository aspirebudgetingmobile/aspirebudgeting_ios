//
//  FileSelectorView.swift
//  Aspire Budgeting
//
//  Created by TeraMo Labs on 10/29/19.
//  Copyright © 2019 TeraMo Labs. All rights reserved.
//

// import GoogleSignIn
import SwiftUI

struct FileSelectorView: View {
  @EnvironmentObject var sheetsManager: GoogleSheetsManager

  @State var selectedFile: File?

  let driveManager: DriveManager

  init(driveManager: DriveManager) {
    self.driveManager = driveManager
  }

  @State private var files: [File] = []
  @State private var error: AspireError?

  var body: some View {
    ZStack {
      ZStack {
        if self.selectedFile == nil {
          NavigationView {
            List(files) { file in
              Button(
                action: {
                  self.sheetsManager.defaultFile = file
                  self.selectedFile = file
                }, label: {
                  Text(file.name)
                }
              )
            }
            .navigationBarTitle("Link your Aspire sheet")
          }.onAppear {
            self.driveManager.getFilesList { result in
              switch result {
              case .success(let files):
                self.files = files
              case .error(let error):
                self.error = error
                print("Error getting files:", error)
              }
            }
          }
        }
        if self.selectedFile != nil {
          AspireMasterView()
        }
      }
      if error != nil {
        Text(error!.description)
      }
    }
  }
}

struct FileSelectorView_Previews: PreviewProvider {
  struct FileError: AspireError {
    var description: String = "Preview Error"
  }

  static var previews: some View {
    getFileSelectorView()
  }

  static func getFileSelectorView() -> FileSelectorView {
    let error = FileError()
    let manager = PreviewDriveManager()
    manager.error = error
    return FileSelectorView(driveManager: manager)
  }
}

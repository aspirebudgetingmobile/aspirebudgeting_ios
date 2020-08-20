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
  let viewModel: FileSelectorViewModel

  var files: [File] {
    viewModel.getFiles() ?? [File]()
  }

  var error: Error? {
    viewModel.getError()
  }

  var body: some View {
    if viewModel.currentState == .isLoading {
      Text("Loading")
    }

    if viewModel.currentState == .filesRetrieved {
      NavigationView {
        List(files) { file in
          Button(
            action: {
              viewModel.fileSelectedCallback?(file)
            }, label: {
              Text(file.name)
            }
          )
        }.navigationBarTitle("Link your Aspire sheet")
      }
    }

    if viewModel.currentState == .error {
      Text("Error Occured: \(error?.localizedDescription ?? "")")
    }
  }
}

 struct FileSelectorView_Previews: PreviewProvider {
    static var previews: some View {
      FileSelectorView(viewModel: FileSelectorViewModel(fileManagerState:
                                                          .error(error: GoogleDriveManagerError.nilAuthorizer),
                                                        fileSelectedCallback: nil))
    }
 }

//
//  FileSelectorView.swift
//  Aspire Budgeting
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

  var filteredFiles: [File] {
    files.filter {
      searchText.isEmpty ? true : $0.name.contains(searchText)
    }
  }

  @State private var searchText = ""

  var body: some View {
    VStack {
      if viewModel.currentState == .isLoading {
        LoadingView()
      }

      if viewModel.currentState == .dataRetrieved {
        NavigationView {
          VStack {
            SearchBar(text: $searchText)
            List(filteredFiles) { file in
              Button(
                action: {
                  self.viewModel.fileSelectedCallback?(file)
                }, label: {
                  HStack {
                    Image.sheetsIcon
                      .renderingMode(.original)
                    Text(file.name)
                      .font(.nunitoBold(size: 16))
                  }.frame(height: 60)
                }
              )
            }.padding(.bottom, 20).navigationBarTitle("Link your Aspire sheet")
          }.background(Color.primaryBackgroundColor.edgesIgnoringSafeArea(.all))
        }
      }

      if viewModel.currentState == .error {
        Text("Error Occured: \(error?.localizedDescription ?? "")")
      }
    }
  }
}

struct FileSelectorView_Previews: PreviewProvider {
  static let files = [File(id: "abc", name: "File 1"),
                      File(id: "def", name: "File 2"),
  ]

  static let viewModel =
    FileSelectorViewModel(fileManagerState:
                            .filesRetrieved(files: FileSelectorView_Previews.files),
                          fileSelectedCallback: nil)
  static var previews: some View {
    Group {
      FileSelectorView(viewModel: FileSelectorView_Previews.viewModel)

      FileSelectorView(viewModel: FileSelectorView_Previews.viewModel)
        .environment(\.colorScheme, .dark)

      FileSelectorView(viewModel: FileSelectorViewModel())
    }
  }
}

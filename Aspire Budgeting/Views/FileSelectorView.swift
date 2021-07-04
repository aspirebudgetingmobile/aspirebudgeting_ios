//
//  FileSelectorView.swift
//  Aspire Budgeting
//

import GoogleSignIn
import SwiftUI

struct FileSelectorView: View {
  @ObservedObject var viewModel: FileSelectorViewModel

  var files: [File] {
    viewModel.files
  }

  var error: Error? {
    viewModel.error
  }

  var filteredFiles: [File] {
    files.filter {
      searchText.isEmpty ? true : $0.name.contains(searchText)
    }
  }

  @State private var searchText = ""

  var body: some View {
    VStack {
      if viewModel.files.isEmpty {
        LoadingView()
      }

      if viewModel.error != nil {
        Text("Error Occured: \(error?.localizedDescription ?? "")")
      }

      if !viewModel.files.isEmpty {
        NavigationView {
          VStack {
            SearchBar(text: $searchText)
            List(filteredFiles) { file in
              Button(
                action: {
                  self.viewModel.selected(file: file)
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
    }
    .onAppear {
      viewModel.getFiles()
    }
  }
}

//struct FileSelectorView_Previews: PreviewProvider {
//  static let files = [File(id: "abc", name: "File 1"),
//                      File(id: "def", name: "File 2"),
//  ]
//
//  static let viewModel =
//    FileSelectorViewModel(fileManagerState:
//                            .filesRetrieved(files: FileSelectorView_Previews.files),
//                          fileSelectedCallback: nil)
//  static var previews: some View {
//    Group {
//      FileSelectorView(viewModel: FileSelectorView_Previews.viewModel)
//
//      FileSelectorView(viewModel: FileSelectorView_Previews.viewModel)
//        .environment(\.colorScheme, .dark)
//
//      FileSelectorView(viewModel: FileSelectorViewModel())
//    }
//  }
//}

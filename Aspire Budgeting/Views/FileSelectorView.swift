//
//  FileSelectorView.swift
//  Aspire Budgeting
//  swiftlint:disable trailing_closure

import GoogleSignIn
import SwiftUI

struct FileSelectorView: View {
  @ObservedObject var viewModel: FileSelectorViewModel

  @State private(set) var showingAlert = false
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
    }.alert(isPresented: $showingAlert, content: {
      Alert(title: Text("Error Occured"),
            message: Text("\(viewModel.error?.localizedDescription ?? "")"),
            dismissButton: .cancel())
    })
    .onReceive(viewModel.$error, perform: { error in
      self.showingAlert = error != nil
    })
    .onAppear {
      viewModel.getFiles()
    }
  }
}

struct FileSelectorView_Previews: PreviewProvider {
  static let files = [File(id: "abc", name: "File 1"),
                      File(id: "def", name: "File 2"),
  ]
  static let fileManager = PreviewFileManager(files: files, error: nil)
  static let aspireSheet = AspireSheet(
    file: files[0],
    dataMap: [String: String]()
  )
  static let fileValidator = PreviewValidator(aspireSheet: aspireSheet, error: nil)

  static let viewModel =
    FileSelectorViewModel(
      fileManager: fileManager,
      fileValidator: fileValidator,
      user: User(name: "First lasr", authorizer: MockAuthorizer())
    )
  static var previews: some View {
    Group {
      FileSelectorView(viewModel: FileSelectorView_Previews.viewModel)

      FileSelectorView(viewModel: FileSelectorView_Previews.viewModel)
        .environment(\.colorScheme, .dark)
    }
  }
}

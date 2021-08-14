//
// SettingsView.swift
// Aspire Budgeting
//

import SwiftUI

struct SettingsView: View {
  let viewModel: SettingsViewModel

  @State private var showShareSheet = false
  @State private var showFileSelector = false

  var body: some View {
    Form {
      Section(footer:
                VStack(alignment: .leading) {
                  Text("Linked Sheet: \(viewModel.fileName)")
                  Text("App Version: \(AspireVersionInfo.version).\(AspireVersionInfo.build)")
                }) {
        Button("Change Sheet") {
          showFileSelector = true
        }
        Button("Export Log File") {
            showShareSheet = true
        }
      }
    }.sheet(isPresented: $showShareSheet) {
      ShareSheet(activityItems: [logURL])
    }
    .sheet(isPresented: $showFileSelector) {
      FileSelectorView(viewModel: viewModel.fileSelectorVM)
    }
    .onReceive(
      viewModel
        .fileSelectorVM
        .$aspireSheet
        .compactMap { $0 }) { _ in
      showFileSelector = false
    }
  }
}

// struct SettingsView_Previews: PreviewProvider {
//    static var previews: some View {
//        SettingsView()
//    }
// }

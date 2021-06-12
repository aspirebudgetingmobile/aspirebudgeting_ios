//
// SettingsView.swift
// Aspire Budgeting
//

import SwiftUI

struct SettingsView: View {
  let viewModel: SettingsViewModel

  @State private var showShareSheet = false
  var body: some View {
    Form {
      Section(footer:
                VStack(alignment: .leading) {
                  Text("Linked Sheet: \(viewModel.fileName)")
                  Text("App Version: \(AspireVersionInfo.version).\(AspireVersionInfo.build)")
                }) {
        Button("Change Sheet") {
          viewModel.changeSheet()
        }
        Button("Export Log File") {
            showShareSheet = true
        }
      }
    }.sheet(isPresented: $showShareSheet) {
      ShareSheet(activityItems: [logURL])
    }
  }
}

//struct SettingsView_Previews: PreviewProvider {
//    static var previews: some View {
//        SettingsView()
//    }
//}

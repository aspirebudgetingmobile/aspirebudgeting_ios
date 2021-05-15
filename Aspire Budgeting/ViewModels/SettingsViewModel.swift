//
// SettingsViewModel.swift
// Aspire Budgeting
//

struct SettingsViewModel {
  let fileName: String
  var changeSheet: () -> Void
  var fileSelectorVM: FileSelectorViewModel
}

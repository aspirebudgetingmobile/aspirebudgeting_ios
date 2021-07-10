//
// FileSelectorViewModel.swift
// Aspire Budgeting
//

import Combine
import Foundation

enum ViewModelState {
  case isLoading
  case dataRetrieved
  case error
}

final class FileSelectorViewModel: ObservableObject {

  @Published private(set) var files = [File]()
  @Published private(set) var error: Error?
  @Published private(set) var aspireSheet: AspireSheet?

  private var cancellables = Set<AnyCancellable>()
  private let fileManager: RemoteFileManager
  private let fileValidator: FileValidator
  private let user: User

  init(
    fileManager: RemoteFileManager,
    fileValidator: FileValidator,
    user: User
  ) {
    self.fileManager = fileManager
    self.fileValidator = fileValidator
    self.user = user
  }

  func getFiles() {
    self.fileManager.getFileList(for: user)
      .sink { completion in
        switch completion {
        case let .failure(error):
          self.error = error
          Logger.info("Failed to retrieve files: \(error)")
        case .finished:
          Logger.info("Files retrieved")
        }
      } receiveValue: { files in
        self.files = files
      }
      .store(in: &cancellables)
  }

  func selected(file: File) {
    fileValidator
      .validate(file: file, for: user)
      .sink { [weak self] completion in
        guard let self = self else { return }
        switch completion {
        case let .failure(error):
          self.error = error
          self.aspireSheet = nil
          Logger.info("Failed to validate: \(file.name) with error: \(error)")
        case .finished:
          Logger.info("Aspire Sheet selected : \(file.name)")
        }
      } receiveValue: { [weak self] aspireSheet in
        guard let self = self else { return }
        self.aspireSheet = aspireSheet
        self.error = nil
      }
      .store(in: &cancellables)
  }
}

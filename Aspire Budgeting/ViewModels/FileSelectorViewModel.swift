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

class FileSelectorViewModel: ObservableObject {

  @Published private(set) var files = [File]()
  @Published private(set) var error: Error?

  let selectedFilePublisher: SelectedFilePublisher

  private var cancellables = Set<AnyCancellable>()
  private let fileManager: RemoteFileManager
  private let userPublisher: AnyPublisher<Result<User>, Never>

  init(
    fileManager: RemoteFileManager,
    userPublisher: AnyPublisher<Result<User>, Never>,
    fileSelectedPublisher: SelectedFilePublisher
  ) {
    self.fileManager = fileManager
    self.userPublisher = userPublisher
    self.selectedFilePublisher = fileSelectedPublisher
  }

  func getFiles() {
    userPublisher
      .tryMap { result -> User in
        switch result {
        case let .success(user):
          return user
        case let .failure(error):
          throw error
        }
      }
      .flatMap {
        self.fileManager.getFileList(for: $0)
      }
      .sink { completion in
        switch completion {
        case let .failure(error):
          self.error = error
        case .finished:
          Logger.info("Files retrieved")
        }
      } receiveValue: { files in
        self.files = files
      }
      .store(in: &cancellables)
  }

  func selected(file: File) {
    selectedFilePublisher.send(file)
  }
}

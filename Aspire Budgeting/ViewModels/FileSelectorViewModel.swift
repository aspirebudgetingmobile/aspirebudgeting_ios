//
// FileSelectorViewModel.swift
// Aspire Budgeting
//

import Foundation

struct FileSelectorViewModel {
  enum State {
    case isLoading
    case filesRetrieved
    case error
  }

  let fileManagerState: RemoteFileManagerState

  typealias FileSelectedCallBack = (File) -> Void
  let fileSelectedCallback: FileSelectedCallBack?

  init(fileManagerState: RemoteFileManagerState,
       fileSelectedCallback: FileSelectedCallBack?) {
    self.fileSelectedCallback = fileSelectedCallback
    self.fileManagerState = fileManagerState
  }

  init() {
    self.init(fileManagerState:
                .filesRetrieved(files: [File]()),
              fileSelectedCallback: nil)
  }

  var currentState: State {
    switch fileManagerState {
    case .isLoading:
      return .isLoading

    case .filesRetrieved:
      return .filesRetrieved

    case .error:
      return .error
    }
  }

  func getFiles() -> [File]? {
    switch fileManagerState {
    case .filesRetrieved(let files):
      return files
    default:
      return nil
    }
  }

  func getError() -> Error? {
    switch fileManagerState {
    case .error(let error):
      return error
    default:
      return nil
    }
  }
}

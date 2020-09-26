//
// FileSelectorViewModel.swift
// Aspire Budgeting
//

import Foundation

enum ViewModelState {
  case isLoading
  case dataRetrieved
  case error
}

struct FileSelectorViewModel {

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

  var currentState: ViewModelState {
    switch fileManagerState {
    case .isLoading:
      return .isLoading

    case .filesRetrieved:
      return .dataRetrieved

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

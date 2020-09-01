//
//  GoogleDriveManager.swift
//  Aspire Budgeting
//

import Combine
import Foundation
import GoogleAPIClientForREST
import GoogleSignIn
import GTMSessionFetcher
import os.log

protocol RemoteFileManager {
  var currentState: CurrentValueSubject<RemoteFileManagerState, Never> { get }
  func getFileList(for user: User)
}

enum RemoteFileManagerState {
  case isLoading
  case error(error: Error)
  case filesRetrieved(files: [File])
}

enum GoogleDriveManagerError: String, Error {
  case nilAuthorizer
  case inconsistentSheet = "Inconsistency found in the selected sheet."
  case noInternet = "No Internet connection available"
}

//TODO: Remove conformance to ObservableObject
final class GoogleDriveManager: ObservableObject, RemoteFileManager {
  static let queryFields: String = "kind,nextPageToken,files(mimeType,id,kind,name)"
  static let spreadsheetMIME: String = "application/vnd.google-apps.spreadsheet"

  private let driveService: GTLRService
  private let googleFilesListQuery: GTLRDriveQuery_FilesList

  private var authorizer: GTMFetcherAuthorizationProtocol?
  private var authorizerNotificationObserver: NSObjectProtocol?

  private var ticket: GTLRServiceTicket?

  private(set) var currentState =
    CurrentValueSubject<RemoteFileManagerState, Never>(.isLoading)

  //TODO: Remove @Published properties
  @Published private(set) var fileList = [File]()
  @Published private(set) var error: Error?

  init(
    driveService: GTLRService = GTLRDriveService(),
    googleFilesListQuery: GTLRDriveQuery_FilesList = GTLRDriveQuery_FilesList.query()
  ) {
    self.driveService = driveService
    self.googleFilesListQuery = googleFilesListQuery
  }

  func getFileList(for user: User) {
    guard let authorizer = user.authorizer as? GTMFetcherAuthorizationProtocol else {
      currentState.value = .error(error: GoogleDriveManagerError.nilAuthorizer)
      return
    }

    fileList.removeAll()

    driveService.authorizer = authorizer
    driveService.shouldFetchNextPages = true

    googleFilesListQuery.fields = GoogleDriveManager.queryFields
    googleFilesListQuery.q = "mimeType='\(GoogleDriveManager.spreadsheetMIME)'"
    ticket = driveService.executeQuery(
      googleFilesListQuery
    ) { [weak self] _, driveFileList, error in
      guard let weakSelf = self else {
        return
      }
      weakSelf.googleFilesListQuery.isQueryInvalid = false

      if let error = error {
        os_log(
          "Error while getting list of files from Google Drive. %{public}s",
          log: .googleDriveManager,
          type: .error,
          error.localizedDescription
        )
        weakSelf.currentState.value = .error(error: error)
        weakSelf.error = error
      } else {
        if let driveFileList = driveFileList as? GTLRDrive_FileList,
          let files = driveFileList.files {
          os_log(
            "File list retrieved. Converting to local model.",
            log: .googleDriveManager,
            type: .default
          )
          weakSelf.fileList = files
            .map { File(driveFile: $0) }
          weakSelf.currentState.value = .filesRetrieved(files: weakSelf.fileList)
        }
      }
    }
  }
}

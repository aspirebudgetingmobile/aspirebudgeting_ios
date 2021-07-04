//
//  GoogleDriveManager.swift
//  Aspire Budgeting
//

import Combine
import Foundation
import GoogleAPIClientForREST
import GoogleSignIn
import GTMSessionFetcher

protocol RemoteFileManager {
//  var currentState: CurrentValueSubject<RemoteFileManagerState, Never> { get }
//  func getFileList(for user: User)
  func getFileList(for user: User) -> AnyPublisher<[File], Error>
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

  func getFileList(for user: User) -> AnyPublisher<[File], Error> {
    Deferred {
      Future { [weak self] promise in
        guard let self = self else { return }
        self.driveService.authorizer = user.authorizer
        self.driveService.shouldFetchNextPages = true

        self.googleFilesListQuery.fields = GoogleDriveManager.queryFields
        self.googleFilesListQuery.q = "mimeType='\(GoogleDriveManager.spreadsheetMIME)'"
        self.ticket =
          self.driveService
          .executeQuery(self.googleFilesListQuery) { [weak self] _, driveFileList, error in
            guard let self = self else {
              return
            }
            self.googleFilesListQuery.isQueryInvalid = false

            if let error = error {
              Logger.error(
                "Error while getting list of files from Google Drive.",
                context: error.localizedDescription
              )
              promise(.failure(error))
            } else {
            if let driveFileList = driveFileList as? GTLRDrive_FileList,
              let files = driveFileList.files {
              Logger.info(
                "File list retrieved. Converting to local model."
                )
              promise(.success(files.map(File.init)))
            }
          }
        }

      }
    }.eraseToAnyPublisher()
  }
}

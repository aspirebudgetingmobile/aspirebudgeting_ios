//
//  GoogleDriveManager.swift
//  Aspire Budgeting
//
//  Created by TeraMo Labs on 10/21/19.
//  Copyright © 2019 TeraMo Labs. All rights reserved.
//

import Foundation
import GoogleAPIClientForREST
import GoogleSignIn
import GTMSessionFetcher
import os.log

protocol DriveManager {
  func getFilesList(completion: @escaping (Result<[File]>) -> Void)
  func cancelGetFilesListRequest()
}

enum GoogleDriveManagerError: AspireError {
  // wouldn't be here when the refactor is done
  case nilAuthorizer
  case inconsistentSheet
  case noInternet
  case other(String)

  var description: String {
    switch self {
    case .nilAuthorizer:
      return "Unable to authorize."
    case .inconsistentSheet:
      return "Inconsistency found in the selected sheet."
    case .noInternet:
      return "No Internet connection available"
    case .other(let string):
      return string
    }
  }
}

protocol DriveService {
  func execute(_ string: String)
  var authorizer: String { set get }
  var nextPages: Bool { get set }
}

final class GoogleDriveManager: ObservableObject {
  static let queryFields: String = "kind,nextPageToken,files(mimeType,id,kind,name)"
  static let spreadsheetMIME: String = "application/vnd.google-apps.spreadsheet"

  private let driveService: GTLRService
  private let googleFilesListQuery: GTLRDriveQuery_FilesList

  private var authorizer: GTMFetcherAuthorizationProtocol?
  private var authorizerNotificationObserver: NSObjectProtocol?

  private var ticket: GTLRServiceTicket?

  init(
    driveService: GTLRService = GTLRDriveService(),
    googleFilesListQuery: GTLRDriveQuery_FilesList = GTLRDriveQuery_FilesList.query()
  ) {
    self.driveService = driveService
    self.googleFilesListQuery = googleFilesListQuery

    subscribeToAuthorizerNotification()
  }

  // TODO: teeks this will be removed and we'll just inject the authorizer
  private func subscribeToAuthorizerNotification() {
    os_log(
      "Subscribing for Google authorizer event",
      log: .googleDriveManager,
      type: .default
    )
    authorizerNotificationObserver = NotificationCenter.default.addObserver(
      forName: .authorizerUpdated,
      object: nil,
      queue: nil
    ) { [weak self] notification in
      guard let weakSelf = self else {
        return
      }

      weakSelf.assignAuthorizer(from: notification)
    }
  }

  private func assignAuthorizer(from notification: Notification) {
    guard let userInfo = notification.userInfo,
      let authorizer = userInfo[Notification.Name.authorizerUpdated]
      as? GTMFetcherAuthorizationProtocol else {
      os_log(
        "No authorizer in notification",
        log: .googleDriveManager,
        type: .error
      )
      return
    }

    os_log(
      "Received authorizer from notification",
      log: .googleDriveManager,
      type: .default
    )
    self.authorizer = authorizer
  }
}

extension GoogleDriveManager: DriveManager {
  func getFilesList(completion: @escaping (Result<[File]>) -> Void) {
    guard let authorizer = authorizer else {
      return completion(.error(GoogleDriveManagerError.nilAuthorizer))
    }

    driveService.authorizer = authorizer
    driveService.shouldFetchNextPages = true

    googleFilesListQuery.fields = GoogleDriveManager.queryFields
    googleFilesListQuery.q = "mimeType='\(GoogleDriveManager.spreadsheetMIME)'"
    ticket = driveService.executeQuery(
      googleFilesListQuery
    ) { [weak self] _, driveFileList, error in
      guard let self = self else {
        return
      }
      self.ticket = nil
      // TODO: teeks unclear on the understanding of this based on documentation
      self.googleFilesListQuery.isQueryInvalid = false

      guard error == nil else {
        self.logError(error!)
        return completion(.error(GoogleDriveManagerError.other(error!.localizedDescription)))
      }

      if let driveFileList = driveFileList as? GTLRDrive_FileList,
        let driveFiles = driveFileList.files {
        os_log(
          "File list retrieved. Converting to local model.",
          log: .googleDriveManager,
          type: .default
        )
        let files = driveFiles.map {
          File(
            id: $0.identifier ?? "No file identifier",
            name: $0.name ?? "No file name"
          )
        }
        completion(.success(files))
      }
    }
  }

  func cancelGetFilesListRequest() {
    ticket?.cancel()
    ticket = nil
  }

  private func logError(_ error: Error) {
    os_log(
      "Error while getting list of files from Google Drive. %{public}s",
      log: .googleDriveManager,
      type: .error,
      error.localizedDescription
    )
  }
}

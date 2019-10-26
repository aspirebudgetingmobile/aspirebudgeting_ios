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

class GoogleDriveManager: ObservableObject {
  static let queryFields: String = "kind,nextPageToken,files(mimeType,id,kind,name,webViewLink,thumbnailLink,trashed)"
  
  private let driveService: GTLRService
  private var ticket: GTLRServiceTicket?
  private let query: GTLRDriveQuery_FilesList
  
  @Published public private(set) var fileList = [File]()
  @Published public private(set) var error: Error?
  
  init(driveService: GTLRService = GTLRDriveService(),
       query: GTLRDriveQuery_FilesList = GTLRDriveQuery_FilesList.query()) {
    self.driveService = driveService
    self.query = query
  }
  
  func getFileList(authorizer: GTMFetcherAuthorizationProtocol) {
    fileList.removeAll()
    query.isQueryInvalid = false
    
    driveService.authorizer = authorizer
    driveService.shouldFetchNextPages = true
    
    query.fields = GoogleDriveManager.queryFields
    ticket = driveService.executeQuery(query, completionHandler: { [weak self] (ticket, driveFileList, error) in
      guard let weakSelf = self else {
        return
      }
      if let error = error {
        weakSelf.error = error
      } else {
        if let driveFileList = driveFileList as? GTLRDrive_FileList,
          let files = driveFileList.files {
          weakSelf.fileList = files.map({ File(driveFile: $0)})
        }
      }
    })
  }
}

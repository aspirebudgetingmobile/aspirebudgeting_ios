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

class GoogleDriveManager: ObservableObject {
  private let driveService = GTLRDriveService()
  
  private var ticket: GTLRServiceTicket?
  
  @Published var fileList = [File]()
  @Published var error: Error?
  
  func getFileList(user: GIDGoogleUser) {
    fileList.removeAll()
    
    let query = GTLRDriveQuery_FilesList.query()
    driveService.authorizer = user.authentication.fetcherAuthorizer()
    driveService.shouldFetchNextPages = true
    driveService.maxRetryInterval = 3
    
    query.fields = "kind,nextPageToken,files(mimeType,id,kind,name,webViewLink,thumbnailLink,trashed)"
    ticket = driveService.executeQuery(query, completionHandler: { [unowned self] (ticket, driveFileList, error) in
      if let error = error {
        self.error = error
      } else {
        if let driveFileList = driveFileList as? GTLRDrive_FileList,
          let files = driveFileList.files {
          self.fileList = files.map({ (driveFile) -> File in
            let name = driveFile.name ?? "no file name"
            let identifier = driveFile.identifier ?? ""
            return File(name: name, identifier: identifier)
          })
        }
      }
    })
  }
}

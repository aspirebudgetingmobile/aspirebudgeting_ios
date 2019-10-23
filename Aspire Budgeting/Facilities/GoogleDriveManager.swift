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

class GoogleDriveManager {
  let driveService = GTLRDriveService()
  
  var ticket: GTLRServiceTicket?
  
  func getFileList(user: GIDGoogleUser) {
    let query = GTLRDriveQuery_FilesList.query()
    driveService.authorizer = user.authentication.fetcherAuthorizer()
    query.fields = "kind,nextPageToken,files(mimeType,id,kind,name,webViewLink,thumbnailLink,trashed)"
    ticket = driveService.executeQuery(query, completionHandler: { (ticket, list, error) in
      let x = list as! GTLRDrive_FileList
      for file in x.files! {
        print(file.name, file.identifier)
      }
    })
  }
}

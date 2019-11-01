//
//  GoogleSheetsManager.swift
//  Aspire Budgeting
//
//  Created by TeraMo Labs on 11/1/19.
//  Copyright © 2019 TeraMo Labs. All rights reserved.
//

import Foundation
import GoogleAPIClientForREST
import GTMSessionFetcher

final class GoogleSheetsManager: ObservableObject {
  
  private let sheetsService: GTLRService
  private let getSpreadsheetsQuery: GTLRSheetsQuery_SpreadsheetsValuesGet
  
  private var authorizer: GTMFetcherAuthorizationProtocol?
  private var authorizerNotificationObserver: NSObjectProtocol?
  
  private var ticket: GTLRServiceTicket?
  
  @Published public private(set) var aspireVersion: String?
  @Published public private(set) var error: Error?
  
  init(sheetsService: GTLRService = GTLRSheetsService(),
       getSpreadsheetsQuery: GTLRSheetsQuery_SpreadsheetsValuesGet =  GTLRSheetsQuery_SpreadsheetsValuesGet.query(withSpreadsheetId: "", range: "")) {
    self.sheetsService = sheetsService
    self.getSpreadsheetsQuery = getSpreadsheetsQuery
    
    subscribeToAuthorizerNotification()
  }
  
  private func subscribeToAuthorizerNotification() {
    authorizerNotificationObserver = NotificationCenter.default.addObserver(forName: .authorizerUpdated, object: nil, queue: nil) { [weak self] (notification) in
      guard let weakSelf = self else {
          return
      }
      
      weakSelf.assignAuthorizer(from: notification)
    }
  }
  
  private func assignAuthorizer(from notification: Notification) {
    guard let userInfo = notification.userInfo,
      let authorizer = userInfo[Notification.Name.authorizerUpdated] as? GTMFetcherAuthorizationProtocol else {
        return
    }
    
    self.authorizer = authorizer
  }
  
  func verifySheet(spreadsheet: File) {
        guard let authorizer = self.authorizer else {
          self.error = GoogleDriveManagerError.nilAuthorizer
          return
        }

        sheetsService.authorizer = authorizer
        getSpreadsheetsQuery.isQueryInvalid = false

        getSpreadsheetsQuery.spreadsheetId = spreadsheet.id
        getSpreadsheetsQuery.range = "BackendData!AC2"
        ticket = sheetsService.executeQuery(getSpreadsheetsQuery, completionHandler: { (_, data, error) in
          if let range = data as? GTLRSheets_ValueRange,
            let version = range.values?.first?.first as? String {
            self.error = nil
            self.aspireVersion = version
          }

          if let error = error as NSError? {
            if error.domain == kGTLRErrorObjectDomain {
              self.error = GoogleDriveManagerError.invalidSheet
            } else {
              self.error = GoogleDriveManagerError.noInternet
            }
          }
        })
      }
}

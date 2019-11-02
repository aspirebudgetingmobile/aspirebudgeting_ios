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

struct CategoryRow: Hashable {
  let categoryName: String
  let available: String
  let spent: String
  let budgeted: String
  
  init(row: [String]) {
    categoryName = row[0]
    available = row[1]
    spent = row[4]
    budgeted = row[7]
  }
}

struct GroupsAndCategories {
  let groups: [String]
  let groupedCategoryRows: [[CategoryRow]]
  
  init(rows:[[String]]) {
    var lastIndex = -1
    var tempGroups = [String]()
    var tempGroupedCategoryRow = [[CategoryRow]]()
    for row in rows {
      if row.count == 1  {
        lastIndex += 1
        tempGroups.append(row[0])
        tempGroupedCategoryRow.append([CategoryRow]())
      } else {
        let categorRow = CategoryRow(row: row)
        tempGroupedCategoryRow[lastIndex].append(categorRow)
      }
    }
    
    groups = tempGroups
    groupedCategoryRows = tempGroupedCategoryRow
  }
  
}

final class GoogleSheetsManager: ObservableObject {
  
  private let sheetsService: GTLRService
  private let getSpreadsheetsQuery: GTLRSheetsQuery_SpreadsheetsValuesGet
  
  private var authorizer: GTMFetcherAuthorizationProtocol?
  private var authorizerNotificationObserver: NSObjectProtocol?
  
  private var ticket: GTLRServiceTicket?
  
  @Published public private(set) var aspireVersion: String?
  @Published public private(set) var error: GoogleDriveManagerError?
  @Published public private(set) var groupsAndCategories: GroupsAndCategories?
  
  init(sheetsService: GTLRService = GTLRSheetsService(),
       getSpreadsheetsQuery: GTLRSheetsQuery_SpreadsheetsValuesGet = GTLRSheetsQuery_SpreadsheetsValuesGet.query(withSpreadsheetId: "", range: "")) {
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
  
  private func fetchData(spreadsheet: File, spreadsheetRange: String, completion: @escaping (GTLRSheets_ValueRange) -> Void) {
    guard let authorizer = self.authorizer else {
      self.error = GoogleDriveManagerError.nilAuthorizer
      return
    }
    
    sheetsService.authorizer = authorizer
    getSpreadsheetsQuery.isQueryInvalid = false
    
    getSpreadsheetsQuery.spreadsheetId = spreadsheet.id
    getSpreadsheetsQuery.range = spreadsheetRange
    
    ticket = sheetsService.executeQuery(getSpreadsheetsQuery, completionHandler: { (_, data, error) in
      if let valueRange = data as? GTLRSheets_ValueRange {
        self.error = nil
        completion(valueRange)
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
  
  func verifySheet(spreadsheet: File) {
    
    fetchData(spreadsheet: spreadsheet, spreadsheetRange: "BackendData!AC2") { (valueRange) in
      if let version = valueRange.values?.first?.first as? String {
        self.aspireVersion = version
      }
    }
  }
  
  func fetchCategoriesAndGroups(spreadsheet: File) {
    fetchData(spreadsheet: spreadsheet, spreadsheetRange: "Dashboard!H4:O") { (valueRange) in
      if let values = valueRange.values as? [[String]] {
        self.groupsAndCategories = GroupsAndCategories(rows: values)
        print(self.groupsAndCategories)
      }
    }
  }
}

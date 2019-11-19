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

extension Notification.Name {
  static let hasSheetInDefaults = Notification.Name("hasSheetInDefaults")
}

protocol AspireUserDefaults {
  func data(forKey defaultName: String) -> Data?
}

extension UserDefaults: AspireUserDefaults {}

final class GoogleSheetsManager: ObservableObject {
  
  static let defaultsSheetsKey = "Aspire_Sheet"
  
  private let sheetsService: GTLRService
  private let getSpreadsheetsQuery: GTLRSheetsQuery_SpreadsheetsValuesGet
  
  private var authorizer: GTMFetcherAuthorizationProtocol?
  private var authorizerNotificationObserver: NSObjectProtocol?
  
  private var ticket: GTLRServiceTicket?
  
  private var userDefaults: AspireUserDefaults
  
  public var defaultFile: File?
  
  @Published public private(set) var aspireVersion: String?
  @Published public private(set) var error: GoogleDriveManagerError?
  @Published public private(set) var dashboardMetadata: DashboardMetadata?
  
  init(sheetsService: GTLRService = GTLRSheetsService(),
       getSpreadsheetsQuery: GTLRSheetsQuery_SpreadsheetsValuesGet = GTLRSheetsQuery_SpreadsheetsValuesGet.query(withSpreadsheetId: "", range: ""),
       userDefaults: AspireUserDefaults = UserDefaults.standard) {
    self.sheetsService = sheetsService
    self.getSpreadsheetsQuery = getSpreadsheetsQuery
    self.userDefaults = userDefaults
    
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
  
  func persistSheetID(spreadsheet: File) {
    do {
      let data = try JSONEncoder().encode(spreadsheet)
      UserDefaults.standard.set(data, forKey: GoogleSheetsManager.defaultsSheetsKey)
    } catch {
      fatalError("This should've never happened!!")
    }
  }
  
  func checkDefaultsForSpreadsheet() {
    guard let data = userDefaults.data(forKey: GoogleSheetsManager.defaultsSheetsKey),
      let file = try? JSONDecoder().decode(File.self, from: data) else {
        return
    }
    
    defaultFile = file
    NotificationCenter.default.post(name: .hasSheetInDefaults, object: nil, userInfo: [Notification.Name.hasSheetInDefaults: file])
  }
  
  func verifySheet(spreadsheet: File) {
    
    fetchData(spreadsheet: spreadsheet, spreadsheetRange: "BackendData!AC2") { (valueRange) in
      if let version = valueRange.values?.first?.first as? String {
        self.aspireVersion = version
        self.persistSheetID(spreadsheet: spreadsheet)
      }
    }
  }
  
  func fetchCategoriesAndGroups(spreadsheet: File) {
    fetchData(spreadsheet: spreadsheet, spreadsheetRange: "Dashboard!H4:O") { (valueRange) in
      if let values = valueRange.values as? [[String]] {
        self.dashboardMetadata = DashboardMetadata(rows: values)
      }
    }
  }
}

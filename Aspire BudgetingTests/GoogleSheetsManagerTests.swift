//
//  GoogleSheetsManagerTests.swift
//  Aspire BudgetingTests
//
//  Created by TeraMo Labs on 11/1/19.
//  Copyright © 2019 TeraMo Labs. All rights reserved.
//

@testable import Aspire_Budgeting
import Combine
import GoogleAPIClientForREST
import XCTest

class GoogleSheetsManagerTests: XCTestCase {
  
  var sinkCancellable: AnyCancellable?
  
  override func setUp() {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  func postNotification() {
    let notification = Notification(name: .authorizerUpdated, object: nil, userInfo: [Notification.Name.authorizerUpdated: MockAuthorizer()])
    NotificationCenter.default.post(notification)
  }
  
  func createMockSpreadsheet() -> GTLRSheets_Spreadsheet {
    let properties = GTLRSheets_SheetProperties()
    properties.title = "test_sheet"
    
    let sheet = GTLRSheets_Sheet()
    sheet.properties = properties
    
    let spreadsheet = GTLRSheets_Spreadsheet()
    spreadsheet.sheets = [sheet]
    
    return spreadsheet
  }
  
  class MockFile: AspireFile {
    var name: String?
    var identifier: String?
  }
  
  func testVerifySheet() {
    let mockValueRange = GTLRSheets_ValueRange()
    mockValueRange.values = [["Version"]]
    let mockQuery = GTLRSheetsQuery_SpreadsheetsValuesGet.query(withSpreadsheetId: "42", range: "range")
    let sheetsService = GTLRSheetsService.mockService(withFakedObject: mockValueRange, fakedError: nil)
    let sheetsManager = GoogleSheetsManager(sheetsService: sheetsService, getSpreadsheetsQuery: mockQuery)
    
    postNotification()
    sheetsManager.verifySheet(spreadsheet: File(driveFile: MockFile()))
    
    let expectation = XCTestExpectation()
    sinkCancellable = sheetsManager.$aspireVersion.dropFirst().sink { (version) in
      XCTAssertEqual("Version", version)
      expectation.fulfill()
    }
    
    wait(for: [expectation], timeout: 5)
  }
}

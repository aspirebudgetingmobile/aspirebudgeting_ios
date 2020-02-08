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

struct MockUserDefaults: AspireUserDefaults {
  func set(_ value: Any?, forKey defaultName: String) {
    
  }
  
  func removeObject(forKey defaultName: String) {
    
  }
  
  let data: Data?
  func data(forKey defaultName: String) -> Data? {
    return data
  }
}

final class GoogleSheetsManagerTests: XCTestCase {
  
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
  
  func testDefaultsForSpreadSheet() {
    var sheetsManager = GoogleSheetsManager(userDefaults: MockUserDefaults(data: nil))
    sheetsManager.checkDefaultsForSpreadsheet()
    
    XCTAssertNil(sheetsManager.defaultFile)
    
    let mockFile = MockFile(name: "Test", identifier: "id")
    let data = try? JSONEncoder().encode(File(driveFile: mockFile))

    sheetsManager = GoogleSheetsManager(userDefaults: MockUserDefaults(data: data))
    
    sheetsManager.checkDefaultsForSpreadsheet()
    
    XCTAssertNotNil(sheetsManager.defaultFile)

  }
  
  func testFetchHandlesError() {
    let mockQuery = GTLRSheetsQuery_SpreadsheetsValuesGet.query(withSpreadsheetId: "", range: "")
    let mockError = NSError(domain: kGTLRErrorObjectDomain, code: 42, userInfo: nil)
    let sheetsService = GTLRSheetsService.mockService(withFakedObject: nil, fakedError: mockError)
    let sheetsManager = GoogleSheetsManager(sheetsService: sheetsService, getSpreadsheetsQuery: mockQuery)
    
    postNotification()
    sheetsManager.fetchCategoriesAndGroups(spreadsheet: File(driveFile: MockFile()))
    
    let expectation = XCTestExpectation()
    
    sinkCancellable = sheetsManager.$error.dropFirst().sink(receiveValue: { (error) in
      XCTAssertEqual(error!, GoogleDriveManagerError.inconsistentSheet)
      expectation.fulfill()
    })
    
    wait(for: [expectation], timeout: 5)
  }
  
  func testFetchCategoriesAndGroups() {
    let mockValueRange = GTLRSheets_ValueRange()
    mockValueRange.values = [["G1"],
                             ["G1:C1", "1", "2", "3", "4", "5", "6", "7"],
                             ["G1:C2", "8", "9", "10", "11", "12", "13", "14"],
                             ["G2"],
                             ["G2:C1", "15", "16", "17", "18", "19", "20", "21"]]
    
    let mockQuery = GTLRSheetsQuery_SpreadsheetsValuesGet.query(withSpreadsheetId: "42", range: "range")
    
    let sheetsService = GTLRSheetsService.mockService(withFakedObject: mockValueRange, fakedError: nil)
    
    let sheetsManager = GoogleSheetsManager(sheetsService: sheetsService, getSpreadsheetsQuery: mockQuery)
    
    postNotification()
    sheetsManager.fetchCategoriesAndGroups(spreadsheet: File(driveFile: MockFile()))
    
    let expectation = XCTestExpectation()
    sinkCancellable = sheetsManager.$dashboardMetadata.dropFirst().sink(receiveValue: { (dGroupsAndCategories) in
      XCTAssertEqual(dGroupsAndCategories?.groups, ["G1", "G2"])
      XCTAssertEqual(dGroupsAndCategories?.groupedCategoryRows[0][0].categoryName, "G1:C1")
      XCTAssertEqual(dGroupsAndCategories?.groupedCategoryRows[0][0].available, "1")
      XCTAssertEqual(dGroupsAndCategories?.groupedCategoryRows[0][0].spent, "4")
      XCTAssertEqual(dGroupsAndCategories?.groupedCategoryRows[0][0].budgeted, "7")
      expectation.fulfill()
    })
    
    wait(for: [expectation], timeout: 5)
  }
  
  func testVerifySheet() {
    let mockValueRange = GTLRSheets_ValueRange()
    mockValueRange.values = [["2.8"]]
    let mockQuery = GTLRSheetsQuery_SpreadsheetsValuesGet.query(withSpreadsheetId: "42", range: "range")
    let sheetsService = GTLRSheetsService.mockService(withFakedObject: mockValueRange, fakedError: nil)
    let sheetsManager = GoogleSheetsManager(sheetsService: sheetsService, getSpreadsheetsQuery: mockQuery)
    
    postNotification()
    sheetsManager.verifySheet(spreadsheet: File(driveFile: MockFile()))
    
    let expectation = XCTestExpectation()
    sinkCancellable = sheetsManager.$aspireVersion.dropFirst().sink { (version) in
      XCTAssertEqual(.twoEight, version)
      expectation.fulfill()
    }
    
    wait(for: [expectation], timeout: 5)
  }
}

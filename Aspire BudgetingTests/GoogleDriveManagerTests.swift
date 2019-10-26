//
//  GoogleDriveManagerTests.swift
//  Aspire BudgetingTests
//
//  Created by TeraMo Labs on 10/25/19.
//  Copyright © 2019 TeraMo Labs. All rights reserved.
//

import XCTest
import GTMSessionFetcher
import GoogleAPIClientForREST
import GoogleSignIn
import Combine

@testable import Aspire_Budgeting
class MockAuthorizer: NSObject, GTMFetcherAuthorizationProtocol {
  func authorizeRequest(_ request: NSMutableURLRequest?, delegate: Any, didFinish sel: Selector) {
    
  }
  
  func stopAuthorization() {
    
  }
  
  func stopAuthorization(for request: URLRequest) {
    
  }
  
  func isAuthorizingRequest(_ request: URLRequest) -> Bool {
    return false
  }
  
  func isAuthorizedRequest(_ request: URLRequest) -> Bool {
    return false
  }
  
  var userEmail: String?
  
  
}

class GoogleDriveManagerTests: XCTestCase {
  
  lazy var mockGTLRFileList: GTLRDrive_FileList = {
    let file1 = createFile(name: "file1", identifier: "id1")
    let file2 = createFile(name: "file2", identifier: "id2")
    
    let list = GTLRDrive_FileList()
    list.files = [file1, file2]
    
    return list
  }()
  
  var mockFileList: [File] {
    return mockGTLRFileList.files!.map({File(driveFile: $0)})
  }
  
  lazy var mockDriveService = GTLRService.mockService(withFakedObject: mockGTLRFileList, fakedError: nil)
  
  var sinkCancellable: AnyCancellable?
  
  func createFile(name: String, identifier: String) -> GTLRDrive_File {
    let file = GTLRDrive_File()
    file.name = name
    file.identifier = identifier
    return file
  }
  override func setUp() {
  }
  
  override func tearDown() {
  }
  
  func testGetFileList() {
    
    let mockQuery = GTLRDriveQuery_FilesList.query()
    let mockAuthorizer = MockAuthorizer()
    let driveManager = GoogleDriveManager(driveService: mockDriveService, query: mockQuery)
    
    driveManager.getFileList(authorizer: mockAuthorizer)
    
    let expectation = XCTestExpectation()
  
    self.sinkCancellable = driveManager.$fileList.collect(2).sink(receiveValue: { (listOfFileList) in
      XCTAssertTrue(listOfFileList[0].isEmpty)
      XCTAssertEqual(listOfFileList[1], self.mockFileList)
      expectation.fulfill()
      })
    
    XCTAssertEqual(mockQuery.fields, GoogleDriveManager.queryFields)
    wait(for: [expectation], timeout: 5)
  }
}

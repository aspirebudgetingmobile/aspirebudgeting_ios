//
//  GoogleDriveManagerTests.swift
//  Aspire BudgetingTests
//
//  Created by TeraMo Labs on 10/25/19.
//  Copyright © 2019 TeraMo Labs. All rights reserved.
//

import Combine
import GoogleSignIn
import GoogleAPIClientForREST
import GTMSessionFetcher
import XCTest

@testable import Aspire_Budgeting
final class MockAuthorizer: NSObject, GTMFetcherAuthorizationProtocol {
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

final class GoogleDriveManagerTests: XCTestCase {
  
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
  
  var mockQuery: GTLRDriveQuery_FilesList {
    return GTLRDriveQuery_FilesList.query()
  }
  
  var mockAuthorizer: MockAuthorizer {
    return MockAuthorizer()
  }
  
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
  
  func testGetFileListError() {
    let mockError = NSError(domain: "aspire_tests", code: 42, userInfo: nil)
    let mockDriveService = GTLRService.mockService(withFakedObject: nil, fakedError: mockError)
    let driveManager = GoogleDriveManager(driveService: mockDriveService, query: mockQuery)
    
    driveManager.getFileList(authorizer: mockAuthorizer)
    
    let errorExpectation = XCTestExpectation()
    self.sinkCancellable = driveManager.$error.dropFirst().sink(receiveValue: { (error) in
      XCTAssertNotNil(error)
      XCTAssertNotNil(error as NSError?)
      
      let nsError = error as NSError?
      XCTAssertEqual(mockError.code, nsError!.code)
      errorExpectation.fulfill()
    })
    
    wait(for: [errorExpectation], timeout: 5)
  }
  
  func testGetFileList() {
  
    let mockQuery = self.mockQuery
    let mockDriveService = GTLRService.mockService(withFakedObject: mockGTLRFileList, fakedError: nil)
    let driveManager = GoogleDriveManager(driveService: mockDriveService, query: mockQuery)
    
    driveManager.getFileList(authorizer: mockAuthorizer)
    
    let expectation = XCTestExpectation()
  
    self.sinkCancellable = driveManager.$fileList.collect(2).sink(receiveValue: { (listOfFileList) in
      XCTAssertTrue(listOfFileList[0].isEmpty)
      XCTAssertEqual(listOfFileList[1], self.mockFileList)
      XCTAssertFalse(mockQuery.isQueryInvalid)
      expectation.fulfill()
      })
    
    XCTAssertEqual(mockQuery.fields, GoogleDriveManager.queryFields)
    wait(for: [expectation], timeout: 5)
  }
}

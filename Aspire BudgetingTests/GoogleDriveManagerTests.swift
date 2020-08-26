//
//  GoogleDriveManagerTests.swift
//  Aspire BudgetingTests
//

import Combine
import GoogleAPIClientForREST
import GoogleSignIn
import GTMSessionFetcher
import XCTest

@testable import Aspire_Budgeting

final class GoogleDriveManagerTests: XCTestCase {
  lazy var mockGTLRFileList: GTLRDrive_FileList = {
    let file1 = createFile(name: "file1", identifier: "id1")
    let file2 = createFile(name: "file2", identifier: "id2")

    let list = GTLRDrive_FileList()
    list.files = [file1, file2]

    return list
  }()

  var mockFileList: [File] {
    return mockGTLRFileList.files!.map { File(driveFile: $0) }
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

  func createMockGTLRService(with fakedObject: Any?, error: Error?) -> GTLRService {
    return GTLRService.mockService(withFakedObject: fakedObject, fakedError: error)
  }

  func postNotification() {
    let notification = Notification(
      name: .authorizerUpdated,
      object: nil,
      userInfo: [
        Notification.Name.authorizerUpdated: MockAuthorizer(),
      ]
    )
    NotificationCenter.default.post(notification)
  }

  func testGetFileListErrorWithoutAuthorizer() {
    let user = User(name: "dummy", authorizer: nil)
    let mockDriveService = createMockGTLRService(with: nil, error: nil)
    let driveManager = GoogleDriveManager(
      driveService: mockDriveService,
      googleFilesListQuery: mockQuery
    )

    driveManager.getFileList(for: user)

    let errorExpectation = XCTestExpectation()
    sinkCancellable = driveManager.currentState.sink { state in
      switch state {
      case .error(error: let error):
        let e = error as? GoogleDriveManagerError
        XCTAssertNotNil(e)
        XCTAssertEqual(e!, GoogleDriveManagerError.nilAuthorizer)
        errorExpectation.fulfill()
      default:
        XCTFail()
      }

    }
    wait(for: [errorExpectation], timeout: 5)
  }

  func testGetFileListErrorWithFakeError() {
    let user = User(name: "dummy", authorizer: mockAuthorizer)
    let mockError = NSError(domain: "aspire_tests", code: 42, userInfo: nil)
    let mockDriveService = createMockGTLRService(with: nil, error: mockError)
    let driveManager = GoogleDriveManager(
      driveService: mockDriveService,
      googleFilesListQuery: mockQuery
    )

    postNotification()
    driveManager.getFileList(for: user)

    let errorExpectation = XCTestExpectation()
    sinkCancellable = driveManager.$error.dropFirst().sink { error in
      XCTAssertNotNil(error)
      XCTAssertNotNil(error as NSError?)

      let nsError = error as NSError?
      XCTAssertEqual(mockError.code, nsError!.code)
      errorExpectation.fulfill()
    }

    wait(for: [errorExpectation], timeout: 5)
  }

  func testGetFileList() {
    let user = User(name: "dummy", authorizer: mockAuthorizer)
    let mockQuery = self.mockQuery
    let mockDriveService = createMockGTLRService(with: mockGTLRFileList, error: nil)
    let driveManager = GoogleDriveManager(
      driveService: mockDriveService,
      googleFilesListQuery: mockQuery
    )

    postNotification()
    driveManager.getFileList(for: user)

    let expectation = XCTestExpectation()

    sinkCancellable = driveManager.$fileList.collect(2).sink { listOfFileList in
      XCTAssertTrue(listOfFileList[0].isEmpty)
      XCTAssertEqual(listOfFileList[1], self.mockFileList)
      XCTAssertFalse(mockQuery.isQueryInvalid)
      expectation.fulfill()
    }

    XCTAssertEqual(mockQuery.fields, GoogleDriveManager.queryFields)
    XCTAssertEqual(mockQuery.q, "mimeType='\(GoogleDriveManager.spreadsheetMIME)'")
    wait(for: [expectation], timeout: 5)
  }
}

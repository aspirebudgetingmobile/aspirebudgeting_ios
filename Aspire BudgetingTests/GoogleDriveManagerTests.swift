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
    mockGTLRFileList.files!.map { File(driveFile: $0) }
  }

  var mockQuery: GTLRDriveQuery_FilesList {
    GTLRDriveQuery_FilesList.query()
  }

  var mockAuthorizer: MockAuthorizer {
    MockAuthorizer()
  }

  var cancellables = Set<AnyCancellable>()

  func createFile(name: String, identifier: String) -> GTLRDrive_File {
    let file = GTLRDrive_File()
    file.name = name
    file.identifier = identifier
    return file
  }

  func createMockGTLRService(with fakedObject: Any?, error: Error?) -> GTLRService {
    GTLRService.mockService(withFakedObject: fakedObject, fakedError: error)
  }

  func testGetFileListPublishesError() {
    let user = User(name: "dummy", authorizer: mockAuthorizer)
    let mockError = NSError(domain: "aspire_tests", code: 42, userInfo: nil)
    let mockDriveService = createMockGTLRService(with: nil, error: mockError)
    let driveManager = GoogleDriveManager(
      driveService: mockDriveService,
      googleFilesListQuery: mockQuery
    )

    let exp = XCTestExpectation()
    driveManager
      .getFileList(for: user)
      .sink { completion in
        switch completion {
        case let .failure(error):
          let nsError = error as NSError
          XCTAssertEqual(mockError, nsError)
          exp.fulfill()
        case .finished:
          XCTFail("Unexpected success")
        }
      } receiveValue: { _ in

      }
      .store(in: &cancellables)

    wait(for: [exp], timeout: 1)
  }

  func testGetFileListPublishesFiles() {
    let user = User(name: "dummy", authorizer: mockAuthorizer)
    let mockQuery = self.mockQuery
    let mockDriveService = createMockGTLRService(with: mockGTLRFileList, error: nil)
    let driveManager = GoogleDriveManager(
      driveService: mockDriveService,
      googleFilesListQuery: mockQuery
    )

    let exp = XCTestExpectation()
    driveManager
      .getFileList(for: user)
      .sink { completion in
        switch completion {
        case .failure:
          XCTFail("Unexpected Failure")
        case .finished:
          exp.fulfill()
        }
      } receiveValue: { files in
        XCTAssertEqual(files, self.mockFileList)
        XCTAssertFalse(mockQuery.isQueryInvalid)
      }
      .store(in: &cancellables)

    XCTAssertEqual(mockQuery.fields, GoogleDriveManager.queryFields)
    XCTAssertEqual(mockQuery.q, "mimeType='\(GoogleDriveManager.spreadsheetMIME)'")
    wait(for: [exp], timeout: 1)
  }
}

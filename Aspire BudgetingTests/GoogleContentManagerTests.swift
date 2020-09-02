//
// GoogleContentManagerTests.swift
// Aspire BudgetingTests
//

@testable import Aspire_Budgeting
import Combine
import GoogleAPIClientForREST
import XCTest

class MockRemoteFileReader: RemoteFileReader {
  let vr1 = GTLRSheets_ValueRange()
  let vr2 = GTLRSheets_ValueRange()

  let vrs: [GTLRSheets_ValueRange]
  var idx = 0

  var file: File?
  var user: User?
  var location: String?

  init() {
    vr1.values = [["2.8"]]
    vr2.values = [
      ["✦", "", "G1"],
      ["✧", "", "G1:C1", "1", "2", "3", "4", "5", "6", "7"],
      ["✧", "", "G1:C2", "8", "9", "10", "11", "12", "13", "14"],
      ["✦", "", "G2"],
      ["✧", "", "G2:C1", "15", "16", "17", "18", "19", "20", "21"],
    ]
    vrs = [vr1, vr2]
  }
  func read(file: File, user: User, location: String) -> AnyPublisher<AnyObject, Error> {
    self.file = file
    self.user = user
    self.location = location

    return Future<AnyObject, Error> { promise in
      promise(.success(self.vrs[self.idx]))
      self.idx += 1
    }.eraseToAnyPublisher()
  }
}

struct MockRemoteFileWriter: RemoteFileWriter {
  func write(file: File, user: User, location: String) {

  }
}

class GoogleContentManagerTests: XCTestCase {

  let reader = MockRemoteFileReader()
  let writer = MockRemoteFileWriter()

  func testGetDashboard() {
    let contentManager =
      GoogleContentManager(fileReader: reader, fileWriter: writer)

    let user = User(name: "Test User", authorizer: 42 as AnyObject)
    let file = File(id: "test_file", name: "Test File")
    let dataMap = ["A": "B"]

    let exp = XCTestExpectation()
    contentManager.getDashboard(for: user, from: file, using: dataMap) {
      switch $0 {
      case .failure:
        XCTFail()

      case .success(let metadata):
        XCTAssertEqual(metadata.groups, ["G1", "G2"])
        XCTAssertEqual(metadata.groupedCategoryRows[0][0].categoryName, "G1:C1")
        XCTAssertEqual(metadata.groupedCategoryRows[0][0].available, "1")
        XCTAssertEqual(metadata.groupedCategoryRows[0][0].spent, "4")
        XCTAssertEqual(metadata.groupedCategoryRows[0][0].budgeted, "7")
        exp.fulfill()
      }
    }
    wait(for: [exp], timeout: 1)

    XCTAssertEqual(user.name, reader.user!.name)
    XCTAssertEqual(file, reader.file!)
    XCTAssertEqual("Dashboard!F4:O", reader.location!)
  }

  func testPerformanceExample() throws {
    // This is an example of a performance test case.
    self.measure {
      // Put the code you want to measure the time of here.
    }
  }

}

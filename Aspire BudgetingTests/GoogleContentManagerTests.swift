//
// GoogleContentManagerTests.swift
// Aspire BudgetingTests
//

@testable import Aspire_Budgeting
import Combine
import GoogleAPIClientForREST
import XCTest

class MockRemoteFileReader: RemoteFileReader {
  let vrs: [GTLRSheets_ValueRange]
  var idx = 0

  var file: File?
  var user: User?
  var location: String?

  init(vr1: GTLRSheets_ValueRange, vr2: GTLRSheets_ValueRange) {
    vrs = [vr1, vr2]
  }

  func read(file: File, user: User, location: String) -> AnyPublisher<Any, Error> {
    self.file = file
    self.user = user
    self.location = location

    return Future<Any, Error> { promise in
      promise(.success(self.vrs[self.idx]))
      self.idx += 1
    }.eraseToAnyPublisher()
  }
}

final class MockDashboardReader: MockRemoteFileReader {
  let vr1 = GTLRSheets_ValueRange()
  let vr2 = GTLRSheets_ValueRange()
  init() {
    vr1.values = [["2.8"]]
    vr2.values = [
      ["✦", "", "G1", "", "", "", "", "", "", ""],
      ["✧", "", "G1:C1", "1", "2", "3", "4", "5", "6", "7"],
      ["✧", "", "G1:C2", "8", "9", "10", "11", "12", "13", "14"],
      ["✦", "", "G2", "", "", "", "", "", "", ""],
      ["✧", "", "G2:C1", "15", "16", "17", "18", "19", "20", "21"],
    ]
    super.init(vr1: vr1, vr2: vr2)
  }
}

final class MockAccountBalancesReader: MockRemoteFileReader {
  let vr1 = GTLRSheets_ValueRange()
  let vr2 = GTLRSheets_ValueRange()
  init() {
    vr1.values = [["3.2.0"]]
    vr2.values = [
      ["Account 1", "$500"],
      ["Additional 1"],
      ["Account 2", "-$50"],
      ["Additional 2"],
    ]
    super.init(vr1: vr1, vr2: vr2)
  }
}

struct MockRemoteFileWriter: RemoteFileWriter {
  func write(file: File, user: User, location: String) {

  }
}

final class GoogleContentManagerTests: XCTestCase {

  let dashboardReader = MockDashboardReader()
  let accountBalancesReader = MockAccountBalancesReader()
  let writer = MockRemoteFileWriter()

  let user = User(name: "Test User", authorizer: 42 as AnyObject)
  let file = File(id: "test_file", name: "Test File")
  let dataMap = ["A": "B"]

  func testGetDashboard() {
    let contentManager =
      GoogleContentManager(fileReader: dashboardReader, fileWriter: writer)

    let exp = XCTestExpectation()
    contentManager.getData(for: user, from: file, using: dataMap) { (result: Result<Dashboard>) in
      switch result {
      case .failure:
        XCTFail()

      case .success(let dashboard):
        XCTAssertEqual(dashboard.groups.count, 2)
        XCTAssertEqual(dashboard.groups[0].title, "G1")
        XCTAssertEqual(dashboard.groups[1].title, "G2")
        XCTAssertEqual(dashboard.groups[0].categories[0].categoryName, "G1:C1")
        XCTAssertEqual(dashboard.groups[0].categories[0].available.stringValue, "1")
        XCTAssertEqual(dashboard.groups[0].categories[0].spent.stringValue, "4")
        XCTAssertEqual(dashboard.groups[0].categories[0].budgeted.stringValue, "7")
        exp.fulfill()
      }
    }
    wait(for: [exp], timeout: 1)

    XCTAssertEqual(user.name, dashboardReader.user!.name)
    XCTAssertEqual(file, dashboardReader.file!)
    XCTAssertEqual("Dashboard!F4:O", dashboardReader.location!)
  }

  func testGetAccountBalances() {
    let contentManager =
      GoogleContentManager(fileReader: accountBalancesReader, fileWriter: writer)

    let exp = XCTestExpectation()
    contentManager.getData(for: user,
                           from: file,
                           using: dataMap) { (result: Result<AccountBalances>) in
      switch result {
      case .failure:
        XCTFail()

      case .success(let accountBalances):
        XCTAssertEqual(accountBalances.accountBalances.count, 2)
        XCTAssertEqual(accountBalances.accountBalances[0].accountName, "Account 1")
        XCTAssertEqual(accountBalances.accountBalances[0].balance.decimalValue, 500)
        XCTAssertEqual(accountBalances.accountBalances[0].additionalText, "Additional 1")
        XCTAssertEqual(accountBalances.accountBalances[1].accountName, "Account 2")
        XCTAssertEqual(accountBalances.accountBalances[1].balance.decimalValue, -50)
        XCTAssertEqual(accountBalances.accountBalances[1].additionalText, "Additional 2")
        exp.fulfill()
      }
    }
    wait(for: [exp], timeout: 1)

    XCTAssertEqual("Dashboard!B8:C", accountBalancesReader.location!)
  }
}

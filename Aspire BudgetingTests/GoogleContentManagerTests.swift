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
  var locations: [String]?

  init(vr1: GTLRSheets_ValueRange, vr2: GTLRSheets_ValueRange) {
    vrs = [vr1, vr2]
  }

  func read(file: File, user: User, locations: [String]) -> AnyPublisher<Any, Error> {
    self.file = file
    self.user = user
    self.locations = locations

    return Future<Any, Error> { promise in
      promise(.success([self.vrs[self.idx]]))
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

final class MockTrxMetadataReader: MockRemoteFileReader {
  let vr1 = GTLRSheets_ValueRange()
  let vr2 = GTLRSheets_ValueRange()
  let vr3 = GTLRSheets_ValueRange()

  init() {
    vr1.values = [["3.2.0"]]
    vr2.values = [["Cat 1"], ["Cat 2"]]
    vr3.values = [["Acc 1"], ["Acc 2"]]
    super.init(vr1: vr1, vr2: vr2)
  }

  override func read(file: File, user: User, locations: [String]) -> AnyPublisher<Any, Error> {
    if idx == 0 {
      return super.read(file: file, user: user, locations: locations)
    }

    return Future<Any, Error> { promise in
      promise(.success([self.vr2, self.vr3]))
    }.eraseToAnyPublisher()
  }
}

struct MockRemoteFileWriter: RemoteFileWriter {
  func write(data: GTLRSheets_ValueRange,
             file: File,
             user: User,
             location: String) -> AnyPublisher<Any, Error> {

    Future<Any, Error> { promise in
      promise(.success(true))
    }.eraseToAnyPublisher()
  }
}

final class GoogleContentManagerTests: XCTestCase {

  let dashboardReader = MockDashboardReader()
  let accountBalancesReader = MockAccountBalancesReader()
  let trxMetadataReader = MockTrxMetadataReader()
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
    XCTAssertEqual("Dashboard!F4:O", dashboardReader.locations?.first!)
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

    XCTAssertEqual("Dashboard!B8:C", accountBalancesReader.locations?.first!)
  }

  func testGetTrxMetadata() {
    let contentManager =
      GoogleContentManager(fileReader: trxMetadataReader, fileWriter: writer)

    let exp = XCTestExpectation()
    contentManager
      .getBatchData(for: user,
                    from: file,
                    using: dataMap) { (result: Result<AddTransactionMetadata>) in
        switch result {
        case .failure:
          XCTFail()

        case .success(let trxMetadata):
          XCTAssertEqual(trxMetadata.transactionAccounts, ["Acc 1", "Acc 2"])
          XCTAssertEqual(trxMetadata.transactionCategories, ["Cat 1", "Cat 2"])
          exp.fulfill()
        }
      }
    wait(for: [exp], timeout: 1)
  }

  func testWriteTransaction() {
    let contentManager =
      GoogleContentManager(fileReader: trxMetadataReader, fileWriter: writer)

    let transaction = Transaction(amount: "$50",
                                  memo: "Memo",
                                  date: Date(),
                                  account: "Account",
                                  category: "Category",
                                  transactionType: .inflow,
                                  approvalType: .pending)
    let exp = XCTestExpectation()
    contentManager.write(data: transaction,
                         for: user,
                         to: file,
                         using: dataMap) { result in
      switch result {
      case .success(let val):
        XCTAssertTrue(val as! Bool)
        exp.fulfill()

      default:
        XCTFail()
      }
      exp.fulfill()
    }
    wait(for: [exp], timeout: 1)
  }
}

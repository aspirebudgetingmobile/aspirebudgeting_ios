//
//  GoogleSheetsManagerTests.swift
//  Aspire BudgetingTests
//

@testable import Aspire_Budgeting
import Combine
import GoogleAPIClientForREST
import XCTest

struct MockGSMDependencies: GSMDependencyCreator {
  var sheetsService: GTLRSheetsService {
    GTLRSheetsService
      .mockService(withFakedObject: fakeObject,
                   fakedError: fakeError)
  }

  var readQuery: GTLRSheetsQuery_SpreadsheetsValuesBatchGet {
    GTLRSheetsQuery_SpreadsheetsValuesBatchGet
      .query(withSpreadsheetId: "42")
  }

  func appendQuery(with object: GTLRSheets_ValueRange,
                   spreadsheetId: String,
                   range: String) -> GTLRSheetsQuery_SpreadsheetsValuesAppend {
    GTLRSheetsQuery_SpreadsheetsValuesAppend
      .query(withObject: object,
             spreadsheetId: spreadsheetId,
             range: range)
  }

  let fakeObject: GTLRObject?
  let fakeError: Error?

  init(fakeObject: GTLRObject?, fakeError: Error?) {
    self.fakeError = fakeError
    self.fakeObject = fakeObject
  }
}

final class GoogleSheetsManagerTests: XCTestCase {
  var sinkCancellable: AnyCancellable?

  func testReadSuccess() {
    let fakeResponse = GTLRSheets_BatchGetValuesResponse()

    let fakeValueRange = GTLRSheets_ValueRange()
    fakeValueRange.values = [["A", "B"]]

    fakeResponse.valueRanges = [fakeValueRange]

    let mockDependencies = MockGSMDependencies(fakeObject: fakeResponse,
                                               fakeError: nil)

    let sheetsManager = GoogleSheetsManager(dependencies: mockDependencies)

    let expectation = XCTestExpectation()
    sinkCancellable = sheetsManager
      .read(file: File(id: "id", name: "FileName"),
            user: User(name: "User", authorizer: MockAuthorizer()),
            locations: ["LOC"])
      .sink(receiveCompletion: { result in
        print(result)
      }, receiveValue: { response in
        guard let values = (response as? [GTLRSheets_ValueRange])?
                .first?
                .values as? [[String]]  else {
          XCTFail()
          expectation.fulfill()
          return
        }

        XCTAssertEqual(values, [["A", "B"]])
        expectation.fulfill()
      })

    wait(for: [expectation], timeout: 1)
  }

  func testReadInconsistentSheet() {
    let fakeError = NSError(domain: kGTLRErrorObjectDomain,
                            code: 42,
                            userInfo: nil)

    let mockDependencies = MockGSMDependencies(fakeObject: nil, fakeError: fakeError)

    let sheetsManager = GoogleSheetsManager(dependencies: mockDependencies)

    let expectation = XCTestExpectation()
    sinkCancellable = sheetsManager
      .read(file: File(id: "id", name: "FileName"),
            user: User(name: "User", authorizer: MockAuthorizer()),
            locations: ["LOC"])
      .sink(receiveCompletion: { result in
        switch result {
        case .failure(let error):
          XCTAssertEqual(error as! GoogleDriveManagerError,
                         GoogleDriveManagerError.inconsistentSheet)
          expectation.fulfill()
        default:
          XCTFail()
        }
      }, receiveValue: { _ in
        XCTFail()
      })

    wait(for: [expectation], timeout: 1)
  }

  func testAppendSuccess() {
    let fakeValueRange = GTLRSheets_ValueRange()
    fakeValueRange.values = [["A", "B"]]

    let updateValueResponse = GTLRSheets_UpdateValuesResponse()
    updateValueResponse.updatedRange = "UpdatedRange"

    let appendValueResponse = GTLRSheets_AppendValuesResponse()
    appendValueResponse.updates = updateValueResponse

    let mockDependencies = MockGSMDependencies(fakeObject: appendValueResponse, fakeError: nil)

    let sheetsManager = GoogleSheetsManager(dependencies: mockDependencies)

    let expectation = XCTestExpectation()
    sinkCancellable = sheetsManager
      .write(data: fakeValueRange,
             file: File(id: "id", name: "FileName"),
             user: User(name: "User", authorizer: MockAuthorizer()),
             location: "LOC")
      .sink(receiveCompletion: { result in
        switch result {
        case .failure:
          XCTFail()
        default:
          expectation.fulfill()
        }
      }, receiveValue: { result in
        XCTAssert(result is Bool)
        XCTAssertTrue(result as! Bool)
        expectation.fulfill()
      })

    wait(for: [expectation], timeout: 1)
  }
}

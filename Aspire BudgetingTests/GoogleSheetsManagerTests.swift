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
    let fakeResponse = GTLRSheets_BatchGetValuesResponse()

    if let fakeVR = self.fakeValueRange {
      fakeResponse.valueRanges = [fakeVR]
    }

    let mockService = GTLRSheetsService
      .mockService(withFakedObject: fakeResponse,
                   fakedError: fakeError)

    return mockService
  }

  var readQuery: GTLRSheetsQuery_SpreadsheetsValuesBatchGet {
    GTLRSheetsQuery_SpreadsheetsValuesBatchGet
      .query(withSpreadsheetId: "42")
  }

  func appendQuery(with object: GTLRSheets_ValueRange,
                   spreadsheetId: String,
                   range: String) -> GTLRSheetsQuery_SpreadsheetsValuesAppend {
    GTLRSheetsQuery_SpreadsheetsValuesAppend
      .query(withObject: GTLRSheets_ValueRange(),
             spreadsheetId: "",
             range: "")
  }

  let fakeValueRange: GTLRSheets_ValueRange?
  let fakeError: Error?

  init(fakeValueRange: GTLRSheets_ValueRange?, fakeError: Error?) {
    self.fakeError = fakeError
    self.fakeValueRange = fakeValueRange
  }
}

final class GoogleSheetsManagerTests: XCTestCase {
  var sinkCancellable: AnyCancellable?

  func testReadSuccess() {
    let fakeValueRange = GTLRSheets_ValueRange()
    fakeValueRange.values = [["A", "B"]]

    let mockDependencies = MockGSMDependencies(fakeValueRange: fakeValueRange,
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

    let mockDependencies = MockGSMDependencies(fakeValueRange: nil, fakeError: fakeError)

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
}

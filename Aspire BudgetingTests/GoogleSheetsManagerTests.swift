//
//  GoogleSheetsManagerTests.swift
//  Aspire BudgetingTests
//

@testable import Aspire_Budgeting
import Combine
import GoogleAPIClientForREST
import XCTest

final class GoogleSheetsManagerTests: XCTestCase {
  var sinkCancellable: AnyCancellable?

  func testReadSuccess() {
    let fakeValueRange = GTLRSheets_ValueRange()
    fakeValueRange.values = [["A", "B"]]

    let fakeResponse = GTLRSheets_BatchGetValuesResponse()
    fakeResponse.valueRanges = [fakeValueRange]

    let mockService = GTLRSheetsService
      .mockService(withFakedObject: fakeResponse,
                   fakedError: nil)

    let mockReadQuery = GTLRSheetsQuery_SpreadsheetsValuesBatchGet
      .query(withSpreadsheetId: "42")

    let mockAppendQuery = GTLRSheetsQuery_SpreadsheetsValuesAppend
      .query(withObject: GTLRSheets_ValueRange(),
             spreadsheetId: "",
             range: "")

    let deps = GoogleSheetsManager.Dependencies(sheetsService: mockService,
                                                getSpreadsheetsQuery: mockReadQuery,
                                                appendQuery: mockAppendQuery)

    let sheetsManager = GoogleSheetsManager(dependencies: deps)

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
}

//
// GoogleSheetsValidatorTests.swift
// Aspire BudgetingTests
//

@testable import Aspire_Budgeting
import Combine
import GoogleAPIClientForREST
import XCTest

final class GoogleSheetsValidatorTests: XCTestCase {

  var cancellables = Set<AnyCancellable>()

  let mockFile = File(id: "abc", name: "ABC")
  let mockUser = User(name: "Eggs", authorizer: MockAuthorizer())

  func createSheetProperties(id: Int, title: String) -> GTLRSheets_SheetProperties {
    let p = GTLRSheets_SheetProperties()
    p.sheetId = NSNumber(value: id)
    p.title = title

    return p
  }

  func createGridRange(id: NSNumber,
                       startCol: NSNumber,
                       endCol: NSNumber,
                       startRow: NSNumber,
                       endRow: NSNumber) -> GTLRSheets_GridRange {
    let g = GTLRSheets_GridRange()
    g.sheetId = id
    g.startColumnIndex = startCol
    g.endColumnIndex = endCol
    g.startRowIndex = startRow
    g.endRowIndex = endRow
    return g
  }

  func testInvalidSheet() {
    let sheet1 = MockSheet(properties: createSheetProperties(id: 42, title: "Sheet1"))

    let nr1 = GTLRSheets_NamedRange()
    nr1.range = createGridRange(id: 42,
                                startCol: 5,
                                endCol: 6,
                                startRow: 7,
                                endRow: 8)
    nr1.name = "Test"

    let mockSpreadsheet = MockSpreadsheet(sheets: [sheet1])
    mockSpreadsheet.namedRanges = [nr1]

    let mockService = GTLRService.mockService(withFakedObject: mockSpreadsheet, fakedError: nil)
    let query = GTLRSheetsQuery_SpreadsheetsGet.query(withSpreadsheetId: "abc")

    let validator = GoogleSheetsValidator(
      sheetsService: mockService,
      sheetsQuery: query
    )

    let exp = XCTestExpectation()

    validator
      .validate(file: mockFile, for: mockUser)
      .sink { completion in
        switch completion {
        case let .failure(error):
          XCTAssertEqual(error as! GoogleSheetsValidationError,
                         GoogleSheetsValidationError.invalidSheet)
          exp.fulfill()

        case.finished:
          XCTFail("Unexpected Success")
        }
      } receiveValue: { _ in

      }
      .store(in: &cancellables)

    wait(for: [exp], timeout: 1)
  }

  func testNoSheetsInSpreadsheet() {
    let mockSpreadsheet = MockSpreadsheet(sheets: nil)
    let mockService = GTLRService.mockService(withFakedObject: mockSpreadsheet, fakedError: nil)
    let query = GTLRSheetsQuery_SpreadsheetsGet.query(withSpreadsheetId: "abc")

    let validator = GoogleSheetsValidator(
      sheetsService: mockService,
      sheetsQuery: query
    )

    let exp = XCTestExpectation()

    validator
      .validate(file: mockFile, for: mockUser)
      .sink { completion in
        switch completion {
        case let .failure(error):
          XCTAssertEqual(error as! GoogleSheetsValidationError,
                         GoogleSheetsValidationError.noSheetsInSpreadsheet)
          exp.fulfill()

        case.finished:
          XCTFail("Unexpected Success")
        }
      } receiveValue: { _ in

      }
      .store(in: &cancellables)
    wait(for: [exp], timeout: 1)
  }

  func testValidationPostsGoogleError() {
    let mockError = NSError(domain: "MockError", code: 42, userInfo: nil)
    let mockService = GTLRService.mockService(withFakedObject: nil, fakedError: mockError)
    let query = GTLRSheetsQuery_SpreadsheetsGet.query(withSpreadsheetId: "abc")

    let validator = GoogleSheetsValidator(
      sheetsService: mockService,
      sheetsQuery: query
    )

    let exp = XCTestExpectation()

    validator
      .validate(file: mockFile, for: mockUser)
      .sink { completion in
        switch completion {
        case let .failure(error):
          XCTAssertEqual(error as NSError, mockError)
          exp.fulfill()

        case.finished:
          XCTFail("Unexpected Success")
        }
      } receiveValue: { _ in

      }
      .store(in: &cancellables)
    wait(for: [exp], timeout: 1)
  }

  func testValidationSuccess() {
    let sheet1 = MockSheet(properties:
                            createSheetProperties(id: 50, title: "Sheet1"))
    let sheet2 = MockSheet(properties:
                            createSheetProperties(id: 42, title: "Sheet2"))

    let nr1 = GTLRSheets_NamedRange()
    nr1.range = createGridRange(id: 50,
                                startCol: 5 /* F (0 based) */,
                                endCol: 6 /* F */,
                                startRow: 7 /* 8 (0 based) */,
                                endRow: 8 /* 8 */)
    nr1.name = "ClearedSymbols"

    let nr2 = GTLRSheets_NamedRange()
    nr2.range = createGridRange(id: 42,
                                startCol: 10 /* K */,
                                endCol: 11 /* K */,
                                startRow: 12 /* 13 */,
                                endRow: 13 /* 13 */)
    nr2.name = "MonthAndYear"

    let nr3 = GTLRSheets_NamedRange()
    nr3.range = createGridRange(id: 50,
                                startCol: 35 /* AJ */,
                                endCol: 40 /* AN */,
                                startRow: 23 /* 24 */,
                                endRow: 28 /* 28 */)
    nr3.name = "TransactionCategories"

    let mockSpreadsheet = MockSpreadsheet(sheets: [sheet1, sheet2])
    mockSpreadsheet.namedRanges = [nr1, nr2, nr3]
    let mockService = GTLRService.mockService(withFakedObject: mockSpreadsheet, fakedError: nil)
    let query = GTLRSheetsQuery_SpreadsheetsGet.query(withSpreadsheetId: "abc")

    let validator = GoogleSheetsValidator(
      sheetsService: mockService,
      sheetsQuery: query
    )

    let exp = XCTestExpectation()

    validator
      .validate(file: mockFile, for: mockUser)
      .sink { completion in
        switch completion {
        case .failure:
          XCTFail("Unexpected Failure")
        case .finished:
          exp.fulfill()
        }
      } receiveValue: { aspireSheet in
        XCTAssertNotNil(aspireSheet.dataMap["MonthAndYear"])
        XCTAssertEqual(aspireSheet.dataMap["MonthAndYear"]!, "Sheet2!K13:K13")
        XCTAssertNotNil(aspireSheet.dataMap["ClearedSymbols"])
        XCTAssertEqual(aspireSheet.dataMap["ClearedSymbols"]!, "Sheet1!F8:F8")
        XCTAssertNotNil(aspireSheet.dataMap["TransactionCategories"])
        XCTAssertEqual(aspireSheet.dataMap["TransactionCategories"]!, "Sheet1!AJ24:AN28")
        XCTAssertEqual(aspireSheet.file, self.mockFile)
      }
      .store(in: &cancellables)
    wait(for: [exp], timeout: 1)
  }

}

//
// GoogleSheetsValidatorTests.swift
// Aspire BudgetingTests
//

@testable import Aspire_Budgeting
import Combine
import GoogleAPIClientForREST
import XCTest

final class GoogleSheetsValidatorTests: XCTestCase {

  var validatorSink: AnyCancellable?


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

  func testValidationSuccess() throws {
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

    let validator = GoogleSheetsValidator(sheetsService: mockService, sheetsQuery: query)

    let mockFile = File(id: "abc", name: "ABC")
    let mockUser = User(name: "Eggs", authorizer: MockAuthorizer())

    validator.validate(file: mockFile, for: mockUser)

    let exp = XCTestExpectation()
    exp.expectedFulfillmentCount = 2
    validatorSink = validator.currentState.sink {
      switch $0 {
      case .dataMapRetrieved(let dataMap):
        XCTAssertNotNil(dataMap["MonthAndYear"])
        XCTAssertEqual(dataMap["MonthAndYear"]!, "Sheet2!K13:K13")
        XCTAssertNotNil(dataMap["ClearedSymbols"])
        XCTAssertEqual(dataMap["ClearedSymbols"]!, "Sheet1!F8:F8")
        XCTAssertNotNil(dataMap["TransactionCategories"])
        XCTAssertEqual(dataMap["TransactionCategories"]!, "Sheet1!AJ24:AN28")
        exp.fulfill()

      case .isLoading:
        exp.fulfill()

      default:
        XCTFail()
      }
    }
    wait(for: [exp], timeout: 1)
  }

}

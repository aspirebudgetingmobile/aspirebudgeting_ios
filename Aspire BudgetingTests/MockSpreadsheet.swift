//
// MockSpreadsheet.swift
// Aspire BudgetingTests
//


import Foundation
import GoogleAPIClientForREST

class MockSpreadsheet: GTLRSheets_Spreadsheet {
  init(sheets: [GTLRSheets_Sheet]) {
    super.init()
    super.sheets = sheets
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

class MockSheet: GTLRSheets_Sheet {
  init(properties: GTLRSheets_SheetProperties) {
    super.init()
    super.properties = properties
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

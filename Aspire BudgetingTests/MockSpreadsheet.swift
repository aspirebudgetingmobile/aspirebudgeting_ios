//
// MockSpreadsheet.swift
// Aspire BudgetingTests
//

import Foundation
import GoogleAPIClientForREST

final class MockSpreadsheet: GTLRSheets_Spreadsheet {
  init(sheets: [GTLRSheets_Sheet]?) {
    super.init()
    super.sheets = sheets
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

final class MockSheet: GTLRSheets_Sheet {
  init(properties: GTLRSheets_SheetProperties) {
    super.init()
    super.properties = properties
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

//
// FileValidator.swift
// Aspire Budgeting
//

import Foundation
import GoogleAPIClientForREST

protocol FileValidator {
  func validate(file: File, completion: (Bool) -> Void)
}

struct GoogleSheetsValidator: FileValidator {

  init(sheetsService: GTLRService = GTLRSheetsService(),
       sheetsQuery: GTLRSheetsQuery_SpreadsheetsGet) {
    <#statements#>
  }
  func validate(file: File, completion: (Bool) -> Void) {

  }
}

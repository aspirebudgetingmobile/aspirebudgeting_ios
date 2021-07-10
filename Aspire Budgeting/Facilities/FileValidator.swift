//
// FileValidator.swift
// Aspire Budgeting
//

import Combine
import Foundation
import GoogleAPIClientForREST
import GTMSessionFetcher

enum FileValidatorState {
  case isLoading
  case dataMapRetrieved([String: String])
  case error(Error)
}

enum GoogleSheetsValidationError: String, Error {
  case noSheetsInSpreadsheet = "No sheets in spreadsheet"
  case noNamedRangesInSpreadsheet = "No named ranges in spreadsheet"
  case internalParsingError = "Internal parsing error"
  case invalidSheet = "Invalid Sheet"
}

protocol FileValidator {
//  var currentState: CurrentValueSubject<FileValidatorState, Never> { get }
  func validate(file: File, for: User) -> AnyPublisher<AspireSheet, Error>
}

final class GoogleSheetsValidator: FileValidator {

  private let sheetsService: GTLRService
  private var sheetsQuery: GTLRSheetsQuery_SpreadsheetsGet

  private let validationSet = ["ClearedSymbols",
                               "MonthAndYear",
                               "TransactionCategories",
                              ]

//  private(set) var currentState = CurrentValueSubject<FileValidatorState, Never>(.isLoading)

  init(sheetsService: GTLRService = GTLRSheetsService(),
       sheetsQuery: GTLRSheetsQuery_SpreadsheetsGet = GTLRSheetsQuery_SpreadsheetsGet
        .query(withSpreadsheetId: "")) {
    self.sheetsService = sheetsService
    self.sheetsQuery = sheetsQuery
  }

  func validate(file: File, for user: User) -> AnyPublisher<AspireSheet, Error> {
    Deferred {
      Future { [weak self] promise in
        guard let self = self else { return }
        self.sheetsService.authorizer = user.authorizer as? GTMFetcherAuthorizationProtocol
        self.sheetsQuery = GTLRSheetsQuery_SpreadsheetsGet.query(withSpreadsheetId: file.id)

        self.sheetsService.executeQuery(self.sheetsQuery) { [weak self] _, data, error in
          guard let self = self else { return }
          if let error = error {
//            self.currentState.value = .error(error)
            promise(.failure(error))
          } else {
            let spreadsheet = data as! GTLRSheets_Spreadsheet

            let sheetNameMap: [NSNumber: String]
            if let sheets = spreadsheet.sheets {
              sheetNameMap = self.generateSheetNameMap(sheets: sheets)
            } else {
//              self.currentState.value =
//                .error(GoogleSheetsValidationError.noSheetsInSpreadsheet)
              promise(.failure(GoogleSheetsValidationError.noSheetsInSpreadsheet))
              return
            }

            if let namedRanges = spreadsheet.namedRanges {
              if let dataMap = self.generateDataMap(namedRanges: namedRanges,
                                                    sheetNameMap: sheetNameMap) {
                if dataMap[self.validationSet[0]] != nil,
                   dataMap[self.validationSet[1]] != nil,
                   dataMap[self.validationSet[2]] != nil {
//                  self.currentState.value = .dataMapRetrieved(dataMap)
                  promise(.success(.init(file: file, dataMap: dataMap)))
                } else {
//                  self.currentState.value =
//                    .error(GoogleSheetsValidationError.invalidSheet)
                  promise(.failure(GoogleSheetsValidationError.invalidSheet))
                }
              } else {
//                self.currentState.value =
//                  .error(GoogleSheetsValidationError.internalParsingError)
                promise(.failure(GoogleSheetsValidationError.internalParsingError))
              }
            } else {
//              self.currentState.value = .error(GoogleSheetsValidationError.noNamedRangesInSpreadsheet)
              promise(.failure(GoogleSheetsValidationError.noNamedRangesInSpreadsheet))
            }
          }
        }
      }
    }.eraseToAnyPublisher()

//    currentState.value = .isLoading
  }
}

// MARK: - Spreadsheet Parsing
extension GoogleSheetsValidator {
  private func generateSheetNameMap(sheets: [GTLRSheets_Sheet]) -> [NSNumber: String] {
    var sheetMap = [NSNumber: String]()
    for sheet in sheets {
      sheetMap[sheet.properties!.sheetId!] = sheet.properties!.title
    }
    return sheetMap
  }

  private func generateDataMap(namedRanges: [GTLRSheets_NamedRange],
                               sheetNameMap: [NSNumber: String]
                              ) -> [String: String]? {

    var result = [String: String]()
    for range in namedRanges {
      guard let gridRange = range.range,
            let rangeName = range.name,
//            let sheetId = gridRange.sheetId,
//            v3.3 of the sheet has sheetID=0 for Dashboard, whichi s treated as NULL.
//            This is a workaround for the timebeing
            let sheetName = sheetNameMap[gridRange.sheetId ?? 0],
            let startColumn = gridRange.startColumnIndex as? Int,
            let startRow = gridRange.startRowIndex as? Int,
            let endColumn = gridRange.endColumnIndex as? Int,
            let endRow = gridRange.endRowIndex as? Int
      else {
        return nil
      }

      let startColLetters = self.getColumnLetter(for: startColumn + 1)
      let endColLetters = self.getColumnLetter(for: endColumn)

      result[rangeName] =
        "\(sheetName)!\(startColLetters)\(startRow + 1):\(endColLetters)\(endRow)"
    }
    return result
  }

  private func getColumnLetter(for number: Int) -> String {
    var num = number
    var result = ""
    let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"

    while num > 0 {
      let position = num % 26
      let index = String.Index(utf16Offset: position > 0 ? position - 1 : 0, in: letters)
      result = "\((position == 0 ? "Z" : String(letters[index])))\(result)"
      num = (num - 1) / 26
    }

    return result
  }
}

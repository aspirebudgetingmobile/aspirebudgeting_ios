//
// ValueRangeCreator.swift
// Aspire Budgeting
//

import Foundation
import GoogleAPIClientForREST

enum ValueRangeCreator {
  static func valueRange(from transaction: Transaction,
                         for version: SupportedLegacyVersion) -> GTLRSheets_ValueRange {

    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    dateFormatter.timeStyle = .none

    let valueRange = GTLRSheets_ValueRange()
    valueRange.majorDimension = kGTLRSheets_ValueRange_MajorDimension_Rows

    var valuesToInsert = [String]()
    valuesToInsert.append(dateFormatter.string(from: transaction.date))

    if transaction.transactionType == 0 {
      valuesToInsert.append("")
      valuesToInsert.append(transaction.amount)
    } else {
      valuesToInsert.append(transaction.amount)
      valuesToInsert.append("")
    }

    valuesToInsert.append(transaction.category)
    valuesToInsert.append(transaction.account)
    valuesToInsert.append(transaction.memo)

    let approvalType = transaction.approvalType

    switch version {
    case .twoEight:
      if approvalType == 0 {
        valuesToInsert.append("🆗")
      } else {
        valuesToInsert.append("⏺")
      }

    case .three, .threeOne, .threeTwo, .threeThree:
      if approvalType == 0 {
        valuesToInsert.append("✅")
      } else {
        valuesToInsert.append("🅿️")
      }
    }

    valueRange.values = [valuesToInsert]
    return valueRange
  }
}

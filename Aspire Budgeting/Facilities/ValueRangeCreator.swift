//
// ValueRangeCreator.swift
// Aspire Budgeting
//

import Foundation
import GoogleAPIClientForREST

enum ValueRangeCreator {
  static func valuerange(from categoryTransfer: CategoryTransfer) -> GTLRSheets_ValueRange {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    dateFormatter.timeStyle = .none

    let valueRange = GTLRSheets_ValueRange()
    valueRange.majorDimension = kGTLRSheets_ValueRange_MajorDimension_Rows

    var valuesToInsert = [String]()
    valuesToInsert.append(dateFormatter.string(from: Date()))
    valuesToInsert.append(categoryTransfer.amount)
    valuesToInsert.append(categoryTransfer.fromCategory.title)
    valuesToInsert.append(categoryTransfer.toCategory.title)
    valuesToInsert.append(categoryTransfer.memo ?? "")

    valueRange.values = [valuesToInsert]
    return valueRange
  }

  static func valueRange(from transaction: Transaction,
                         for version: SupportedLegacyVersion) -> GTLRSheets_ValueRange {

    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    dateFormatter.timeStyle = .none

    let valueRange = GTLRSheets_ValueRange()
    valueRange.majorDimension = kGTLRSheets_ValueRange_MajorDimension_Rows

    var valuesToInsert = [String]()
    valuesToInsert.append(dateFormatter.string(from: transaction.date))

    if transaction.transactionType == .inflow {
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
      if approvalType == .approved {
        valuesToInsert.append("🆗")
      } else {
        valuesToInsert.append("⏺")
      }

    case .three, .threeOne, .threeTwo, .threeThree:
      if approvalType == .approved {
        valuesToInsert.append("✅")
      } else {
        valuesToInsert.append("🅿️")
      }
    }

    valueRange.values = [valuesToInsert]
    return valueRange
  }
}

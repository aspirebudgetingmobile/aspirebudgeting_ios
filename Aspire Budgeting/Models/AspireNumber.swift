//
//  AspireNumber.swift
//  Aspire Budgeting
//

import Foundation

infix operator /|
struct AspireNumber: Equatable, Hashable {
  let stringValue: String
  let decimalValue: Decimal
  let isNegative: Bool

  init(stringValue: String) {
    let numFormatter = NumberFormatter()
    numFormatter.numberStyle = .currency
    numFormatter.minimumFractionDigits = 2

    self.init(
      stringValue: stringValue,
      decimalValue: numFormatter.number(from: stringValue)?.decimalValue ?? 0
    )
  }

  init(
    stringValue: String = "",
    decimalValue: Decimal = 0
  ) {
    self.stringValue = stringValue
    self.decimalValue = decimalValue
    isNegative = decimalValue < 0
  }

  /// Get the ratio of two AspireNumbers as a Double
  /// - parameter num : The numerator
  /// - parameter den : The denominator
  /// - returns: 1 if den is 0, fraction otherwise.
  static func /| (num: AspireNumber, den: AspireNumber) -> Double {
    if den.decimalValue == 0 {
      return 1
    }
    return Double(truncating: (num.decimalValue / den.decimalValue) as NSNumber)
  }

  static func >= (lhs: AspireNumber, rhs: AspireNumber) -> Bool {
    lhs.decimalValue >= rhs.decimalValue
  }
}

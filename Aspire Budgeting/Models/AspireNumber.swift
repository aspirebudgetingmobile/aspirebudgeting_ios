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
  /// - returns: 0 if: num is negative or num is 0;
  ///            1 if: den is 0 or num is greater than den or ratio is greater than 1
  static func /| (num: AspireNumber, den: AspireNumber) -> Double {
    if num.isNegative || num.decimalValue == 0 {
      return 0
    }

    if den.decimalValue == 0 || num.decimalValue > den.decimalValue {
      return 1
    }

    let ratio = Double(truncating: (num.decimalValue / den.decimalValue) as NSNumber)
    return ratio > 1 ? 1 : ratio
  }

  static func >= (lhs: AspireNumber, rhs: AspireNumber) -> Bool {
    lhs.decimalValue >= rhs.decimalValue
  }
}

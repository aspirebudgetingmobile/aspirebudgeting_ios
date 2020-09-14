//
//  AspireNumber.swift
//  Aspire Budgeting
//
//  Created by TeraMo Labs on 11/21/19.
//  Copyright © 2019 TeraMo Labs. All rights reserved.
//

import Foundation

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

  static func /(num: AspireNumber, den: AspireNumber) -> Double {
    if den.decimalValue == 0 {
      return 1
    }
    return Double(truncating: (num.decimalValue / den.decimalValue) as NSNumber)
  }
}

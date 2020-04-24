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
    
    self.init(stringValue: stringValue, decimalValue: numFormatter.number(from: stringValue)?.decimalValue ?? 0)
  }
  
  init(stringValue: String = "",
       decimalValue: Decimal = 0) {
    self.stringValue = stringValue
    self.decimalValue = decimalValue
    self.isNegative = decimalValue < 0
  }
}

//
// AspireNumberView.swift
// Aspire Budgeting
//

import SwiftUI

struct AspireNumberView: View {
  let number: AspireNumber
    var body: some View {
      Text(number.stringValue)
        .font(.karlaBold(size: 16))
        .foregroundColor(number.isNegative ? .redPinkFondEndColor : .greenFondEndColor)

    }
}

struct AspireNumberView_Previews: PreviewProvider {
    static var previews: some View {
      Group {
        AspireNumberView(number: AspireNumber(stringValue: "$50"))
        AspireNumberView(number: AspireNumber(stringValue: "-$50"))
      }

    }
}

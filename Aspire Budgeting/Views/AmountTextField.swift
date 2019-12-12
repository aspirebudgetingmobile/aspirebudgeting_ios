//
//  AmountTextField.swift
//  Aspire Budgeting
//
//  Created by TeraMo Labs on 12/11/19.
//  Copyright © 2019 TeraMo Labs. All rights reserved.
//

import SwiftUI

struct AmountTextField: View {
  @Binding var amount: String
  
  private var numFormatter: NumberFormatter {
    let numFormatter = NumberFormatter()
    numFormatter.numberStyle = .currency
    numFormatter.minimumFractionDigits = 2
    
    return numFormatter
  }
  
  var body: some View {
    ZStack {
      Rectangle()
        .foregroundColor(Colors.segmentRed)
        .frame(height: 50)
        .cornerRadius(5)
        .padding()
        .opacity(0.95)
      
      HStack {
        Image("pen_icon").padding(.horizontal)
        Spacer()
        TextField("Enter Amount", text: $amount)
          .keyboardType(.decimalPad)
          .padding(.horizontal)
          .foregroundColor(Color.white)
          .font(.rubikMedium(size: 18))
      }.padding()
    }
  }
}

//struct AmountTextField_Previews: PreviewProvider {
//    static var previews: some View {
//        AmountTextField()
//    }
//}

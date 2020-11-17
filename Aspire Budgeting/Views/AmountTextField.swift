//
//  AmountTextField.swift
//  Aspire Budgeting
//

import SwiftUI

struct AspireTextField: View {
  @Binding var amount: String

  var body: some View {
    ZStack {
      Rectangle()
        .foregroundColor(Color(red: 0.769, green: 0.769, blue: 0.769))
        .frame(height: 50)
        .cornerRadius(5)
        .padding()
        .opacity(0.95)

      HStack {
        Image("dollar_icon").padding(.horizontal)
        Spacer()
        TextField("Enter Amount", text: $amount)
          .keyboardType(.decimalPad)
          .padding(.horizontal)
          .foregroundColor(Color(red: 0.208, green: 0.216, blue: 0.282))
          .font(.rubikMedium(size: 18))
      }.padding()
    }
  }
}

// struct AmountTextField_Previews: PreviewProvider {
//    static var previews: some View {
//        AmountTextField()
//    }
// }

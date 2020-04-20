//
//  AmountTextField.swift
//  Aspire Budgeting
//
//  Created by TeraMo Labs on 12/11/19.
//  Copyright © 2019 TeraMo Labs. All rights reserved.
//

import SwiftUI

struct AspireTextField: View {
  @Binding var text: String
  
  let placeholder: String
  let imageName: String
  
  var body: some View {
    ZStack {
      Rectangle()
        .foregroundColor(Color.init(red: 0.769, green: 0.769, blue: 0.769))
        .frame(height: 50)
        .cornerRadius(5)
        .padding()
        .opacity(0.95)
      
      HStack {
        Image(imageName).padding(.horizontal)
        Spacer()
        TextField(placeholder, text: $text)
          .keyboardType(.decimalPad)
          .padding(.horizontal)
          .foregroundColor(Color(red: 0.208, green: 0.216, blue: 0.282))
          .font(.nunitoSemiBold(size: 25))
      }.padding()
    }
  }
}

//struct AmountTextField_Previews: PreviewProvider {
//    static var previews: some View {
//        AmountTextField()
//    }
//}

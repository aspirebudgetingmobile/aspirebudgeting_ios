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
  let keyboardType: UIKeyboardType
  let disabled: Bool
  
  init(text: Binding<String>, placeHolder: String, imageName: String,
       keyboardType: UIKeyboardType,
       disabled: Bool = false) {
    self._text = text
    self.placeholder = placeHolder
    self.imageName = imageName
    self.keyboardType = keyboardType
    self.disabled = disabled
  }
  
  var body: some View {
    ZStack {
      Rectangle()
        .foregroundColor(Color.init(red: 0.769, green: 0.769, blue: 0.769))
        .frame(height: 50)
        .cornerRadius(5)
        .padding()
      
      HStack {
        Image(imageName).padding(.horizontal)
        Spacer()
        TextField(placeholder, text: $text)
          .keyboardType(keyboardType)
          .padding(.horizontal)
          .foregroundColor(Color(red: 0.208, green: 0.216, blue: 0.282))
          .font(.nunitoSemiBold(size: 25))
        .disabled(disabled)
      }.padding()
    }
  }
}

//struct AmountTextField_Previews: PreviewProvider {
//    static var previews: some View {
//        AmountTextField()
//    }
//}

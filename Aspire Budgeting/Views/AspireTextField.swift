//
//  AmountTextField.swift
//  Aspire Budgeting
//

import SwiftUI

struct AspireTextField: View {
  @Binding var text: String

  let placeholder: String
  let keyboardType: UIKeyboardType
  let disabled: Bool

  init(
    text: Binding<String>,
    placeHolder: String,
    imageName: String,
    keyboardType: UIKeyboardType,
    disabled: Bool = false
  ) {
    self._text = text
    self.placeholder = placeHolder
    self.keyboardType = keyboardType
    self.disabled = disabled
  }

  var body: some View {
    ZStack {
      RoundedRectangle(cornerRadius: 5)
        .strokeBorder(Color(#colorLiteral(red: 0.8470588326454163, green: 0.8470588326454163, blue: 0.8470588326454163, alpha: 1)), lineWidth: 1)
        .frame(height: 50)
        .padding()

      TextField(placeholder, text: $text)
        .keyboardType(keyboardType)
        .padding(.horizontal)
        .foregroundColor(Color(red: 0.208, green: 0.216, blue: 0.282))
        .font(.nunitoSemiBold(size: 25))
        .disabled(disabled)
        .padding()
    }
  }
}

// struct AmountTextField_Previews: PreviewProvider {
//    static var previews: some View {
//        AmountTextField()
//    }
// }

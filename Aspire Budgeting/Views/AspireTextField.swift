//
//  AspireTextField.swift
//  Aspire Budgeting
//

import SwiftUI

struct AspireTextField: View {
  @Binding var text: String

  let placeholder: String
  let keyboardType: UIKeyboardType
  let disabled: Bool
  let leftImage: Image?

  init(
    text: Binding<String>,
    placeHolder: String,
    keyboardType: UIKeyboardType,
    disabled: Bool = false,
    leftImage: Image? = nil
  ) {
    self._text = text
    self.placeholder = placeHolder
    self.keyboardType = keyboardType
    self.disabled = disabled
    self.leftImage = leftImage
  }

  var body: some View {
      HStack {
        if self.leftImage != nil {
          leftImage!
            .resizable()
            .scaledToFit()
            .frame(width: 30, height: 30, alignment: .center)
        }

        TextField(placeholder, text: $text)
          .keyboardType(keyboardType)
          .padding(.horizontal)
          .foregroundColor(Color(red: 0.208, green: 0.216, blue: 0.282))
          .font(.nunitoSemiBold(size: 20))
          .disabled(disabled)
          .frame(height: 40)
          .overlay(
            RoundedRectangle(cornerRadius: 5)
              .stroke(Color(#colorLiteral(red: 0.8470588326454163, green: 0.8470588326454163, blue: 0.8470588326454163, alpha: 1)), lineWidth: 1)
          )
      }
  }
}

 struct AspireTextField_Previews: PreviewProvider {
    static var previews: some View {
      AspireTextField(
        text: .constant("Text Field"),
        placeHolder: "Placeholder",
        keyboardType: .numberPad,
        leftImage: Image.bankNote
      )
    }
 }

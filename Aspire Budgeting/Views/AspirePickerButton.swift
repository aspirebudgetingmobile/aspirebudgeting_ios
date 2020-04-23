//
//  AspirePickerButton.swift
//  Aspire Budgeting
//
//  Created by TeraMo Labs on 4/20/20.
//  Copyright © 2020 TeraMo Labs. All rights reserved.
//

import SwiftUI

struct AspirePickerButton: View {
  @State var text: String
  let title: String
  let imageName: String
  let action: () -> Void
  
  init(title: String, imageName: String,
       action: @escaping () -> Void) {
    _text = State(initialValue: "")
    self.title = title
    self.imageName = imageName
    self.action = action
  }
  
  var body: some View {
    Button(action: action) {
      AspireTextField(text: $text, placeHolder: title, imageName: "calendar_icon", keyboardType: .default, disabled: true)
    }.buttonStyle(PlainButtonStyle())
  }
}

//struct AspirePickerButton_Previews: PreviewProvider {
//    static var previews: some View {
//        AspirePickerButton()
//    }
//}

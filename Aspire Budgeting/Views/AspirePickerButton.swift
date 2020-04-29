//
//  AspirePickerButton.swift
//  Aspire Budgeting
//
//  Created by TeraMo Labs on 4/20/20.
//  Copyright © 2020 TeraMo Labs. All rights reserved.
//

import SwiftUI

struct AspirePickerButton: View {
  let title: String
  let imageName: String
  let action: () -> Void

  init(title: String, imageName: String,
       action: @escaping () -> Void) {
    self.title = title
    self.imageName = imageName
    self.action = action
  }

  var body: some View {
    Button(action: action) {
      ZStack {
        Rectangle()
          .foregroundColor(Color(red: 0.769, green: 0.769, blue: 0.769))
          .frame(height: 50)
          .cornerRadius(5)

        HStack {
          Image(imageName)
            .padding(.horizontal)
          Text(self.title)
            .padding(.horizontal)
            .foregroundColor(Color(red: 0.208, green: 0.216, blue: 0.282))
            .font(.nunitoSemiBold(size: 25))
            .frame(maxWidth: .infinity, alignment: .leading)
        }
      }
    }
    .buttonStyle(PlainButtonStyle())
    .padding()
  }
}

// struct AspirePickerButton_Previews: PreviewProvider {
//    static var previews: some View {
//        AspirePickerButton()
//    }
// }

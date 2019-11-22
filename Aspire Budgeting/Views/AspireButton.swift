//
//  GreenButton.swift
//  Aspire Budgeting
//
//  Created by TeraMo Labs on 11/15/19.
//  Copyright © 2019 TeraMo Labs. All rights reserved.
//

import SwiftUI

struct AspireButton: View {
  enum `Type` {
    case red
    case green
  }
  
  struct ButtonBackgroundView: ViewModifier {
    let fillGradient: LinearGradient
    
    init(fillGradient: LinearGradient) {
      self.fillGradient = fillGradient
    }
    
    func body(content: Content) -> some View {
      content.padding().frame(minWidth: 0, maxWidth: .infinity)
      .background(Capsule().fill(fillGradient))
      .foregroundColor(.white)
    }
  }
  
  let title: String
  let action: () -> Void
  let type: Type
  
  let imageName: String?
  
  func gradient(for type: `Type`) -> LinearGradient {
    switch type {
    case .green:
      return Colors.greenGradient
    default:
      return Colors.redGradient
    }
  }
  
  init(title: String,
       type: `Type`,
       imageName: String? = nil,
       action: @escaping () -> Void) {
    self.title = title
    self.type = type
    self.imageName = imageName
    self.action = action
  }
  
    var body: some View {
      Button(action: action) {
        if imageName == nil {
          Text(title).tracking(1.5).font(.custom("Rubik-Regular", size: 16)).modifier(ButtonBackgroundView(fillGradient: self.gradient(for: self.type)))
        } else {
          HStack {
            Spacer()
            Image(imageName!).resizable().aspectRatio(contentMode: .fit)
            Spacer()
            Text(title).tracking(1.5).font(.custom("Rubik-Regular", size: 16))
            Spacer()
          }.modifier(ButtonBackgroundView(fillGradient: self.gradient(for: self.type)))
        }

      }
    }
}

//struct AspireButton_Previews: PreviewProvider {
//    static var previews: some View {
//        AspireButton()
//    }
//}

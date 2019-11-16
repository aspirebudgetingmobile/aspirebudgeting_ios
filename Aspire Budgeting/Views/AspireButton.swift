//
//  GreenButton.swift
//  Aspire Budgeting
//
//  Created by TeraMo Labs on 11/15/19.
//  Copyright © 2019 TeraMo Labs. All rights reserved.
//

import SwiftUI

struct AspireButton<Content: View>: View {
  enum `Type` {
    case red
    case green
  }
  
  let action: () -> Void
  let content: Content
  let type: Type
  
  func gradient(for type: `Type`) -> LinearGradient {
    switch type {
    case .green:
      return LinearGradient(gradient: Gradient(colors: [Color(red: 95/255, green: 224/255, blue: 170/255), Color(red: 32/255, green: 172/255, blue: 122/255)]), startPoint: .top, endPoint: .bottom)
    default:
      return LinearGradient(gradient: Gradient(colors: [Color(red: 249/255, green: 121/255, blue: 124/255), Color(red: 213/255, green: 103/255, blue: 106/255)]), startPoint: .top, endPoint: .bottom)
    }
  }
  
  init(type: `Type`, action: @escaping () -> Void, @ViewBuilder content: () -> Content) {
    self.action = action
    self.content = content()
    self.type = type
  }
  
    var body: some View {
      Button(action: action) {
        content.padding().frame(minWidth: 0, maxWidth: .infinity)
          .background(Capsule().fill(self.gradient(for: self.type)))
          .foregroundColor(.white)
      }
    }
}

//struct AspireButton_Previews: PreviewProvider {
//    static var previews: some View {
//        AspireButton()
//    }
//}

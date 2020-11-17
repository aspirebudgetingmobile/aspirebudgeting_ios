//
//  BacgroundColorView.swift
//  Aspire Budgeting
//

import SwiftUI

struct BackgroundSplitColorView: View {
  var body: some View {
    ZStack {
      Color(red: 53 / 255, green: 55 / 255, blue: 72 / 255)
      GeometryReader { geometry in
        Path { path in
          let screenWidth = geometry.size.width
          let screenHeight = geometry.size.height

          path.move(to: CGPoint(x: 0, y: 0.43 * screenHeight))
          path.addLine(to: CGPoint(x: 0, y: screenHeight))
          path.addLine(to: CGPoint(x: screenWidth, y: screenHeight))
          path.addLine(to: CGPoint(x: screenWidth, y: 0.55 * screenHeight))
        }.fill(Color.white)
      }
    }.edgesIgnoringSafeArea(.all)
  }
}

struct BackgroundColorView_Previews: PreviewProvider {
  static var previews: some View {
    BackgroundSplitColorView()
  }
}

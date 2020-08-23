//
// LoadingView.swift
// Aspire Budgeting
//

import SwiftUI

struct LoadingView: View {
  @State var isAnimating = false

  let itemsPerRow = 6

  var numberOfRows: Int {
    let heightPerRow = UIScreen.main.bounds.width/CGFloat(itemsPerRow)
    return Int(UIScreen.main.bounds.height/heightPerRow) + 1
  }

  var randomCurrencySymbol: Image {
    let count = Image.currencySymbols.count
    return Image.currencySymbols[Int.random(in: 0..<count)]
  }
    var body: some View {
      VStack(spacing: 0) {
        ForEach(0..<numberOfRows) { _ in
          HStack(spacing: 0) {
            ForEach(0..<itemsPerRow) { _ in
              self.randomCurrencySymbol
                .frame(width: UIScreen.main.bounds.width / CGFloat(self.itemsPerRow),
                       height: UIScreen.main.bounds.width / CGFloat(self.itemsPerRow))
                .opacity(self.isAnimating ? 0.8 : 0)
                .animation(
                  Animation
                    .linear(duration: Double.random(in: 1...2))
                    .repeatForever(autoreverses: true)
                    .delay(Double.random(in: 0...1.5))
                )
            }
          }
        }
      }.onAppear {
        self.isAnimating = true
      }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
      LoadingView()
    }
}

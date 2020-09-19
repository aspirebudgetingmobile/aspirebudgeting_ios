//
//  CardListView.swift
//  Aspire Budgeting
//

import SwiftUI

struct CardListView: View {

  let cardViewItems: [CardView.CardViewItem]

  var body: some View {
    GeometryReader {g in
      ScrollView {
        VStack {
          ForEach(0..<self.cardViewItems.count) { idx in
            GeometryReader { geo in
              CardView(colorInfo: CardListView.colorInfos[idx % CardListView.colorInfos.count],
                       cardViewItem: self.cardViewItems[idx],
                       minY: g.frame(in: .global).minY,
                       curY: geo.frame(in: .global).minY)
                .padding(.horizontal)
            }.frame(maxWidth: .infinity)
              .frame(height: 125)
          }
        }
      }.background(Color.primaryBackgroundColor)
    }
  }
}

extension CardListView {
  static let colorInfos: [CardView.ColorInfo] =
    [.init(gradientStartColor: .blueGreenFondStartColor,
           gradientEndColor: .blueGreenFondEndColor,
           shadowColor: .blueGreenFondShadowColor),
     .init(gradientStartColor: .blueFondStartColor,
           gradientEndColor: .blueFondEndColor,
           shadowColor: .blueFondShadowColor),
     .init(gradientStartColor: .lilacFondStartColor,
           gradientEndColor: .lilacFondEndColor,
           shadowColor: .lilacFondShadowColor),
     .init(gradientStartColor: .mauveBlueFondStartColor,
           gradientEndColor: .mauveBlueFondEndColor,
           shadowColor: .mauveBlueFondShadowColor),
     .init(gradientStartColor: .creamFondStartColor,
           gradientEndColor: .creamFondEndColor,
           shadowColor: .creamFondShadowColor),
     .init(gradientStartColor: .redOrangeFondStartColor,
           gradientEndColor: .redOrangeFondEndColor,
           shadowColor: .redOrangeFondShadowColor),
     .init(gradientStartColor: .blueGradientFondStartColor,
           gradientEndColor: .blueGradientFondEndColor,
           shadowColor: .blueGradientFondShadowColor),
     .init(gradientStartColor: .yellowFondStartColor,
           gradientEndColor: .yellowFondEndColor,
           shadowColor: .yellowFondShadowColor),
     .init(gradientStartColor: .redPinkFondStartColor,
           gradientEndColor: .redPinkFondEndColor,
           shadowColor: .redPinkFondShadowColor),
     .init(gradientStartColor: .greenFondStartColor,
           gradientEndColor: .greenFondEndColor,
           shadowColor: .greenFondShadowColor),
     .init(gradientStartColor: .purpleFondStartColor,
           gradientEndColor: .purpleFondEndColor,
           shadowColor: .purpleFondShadowColor),
    ]
}

struct CardListView_Previews: PreviewProvider {
  static var previews: some View {
    CardListView(cardViewItems: MockProvider.cardViewItems)
  }
}

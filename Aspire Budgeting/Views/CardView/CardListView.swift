//
//  CardListView.swift
//  Aspire Budgeting
//

import SwiftUI

struct CardListView: View {

  let cardViewItems: [CardView.CardViewItem]
  @State private var selectedIndex = -1

  let colorInfos: [CardView.ColorInfo] =
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

  var body: some View {
    GeometryReader {g in
      ScrollView {
        VStack {
          ForEach(0..<10) { idx in
            GeometryReader { geo in
              CardView(cardIndex: idx,
                       colorInfo: self.colorInfos[idx],
                       cardViewItem: self.cardViewItems[idx],
                       minY: g.frame(in: .global).minY,
                       curY: geo.frame(in: .global).minY,
                       selectedIndex: self.$selectedIndex)
                .padding(.horizontal)
            }.frame(maxWidth: .infinity)
              .frame(height: 125)
          }
        }
      }
    }
  }
}

struct CardListView_Previews: PreviewProvider {
  static var previews: some View {
    CardListView(cardViewItems: MockProvider.cardViewItems)
  }
}

//
//  CardListView.swift
//  Aspire Budgeting
//

import SwiftUI

struct CardListView: View {

  let cardViewItems: [BaseCardView.CardViewItem]

  var body: some View {
    GeometryReader {g in
      ScrollView {
        VStack {
          ForEach(0..<self.cardViewItems.count) { idx in
            GeometryReader { geo in
              BaseCardView(colorInfo: CardListView.colorInfos[idx % CardListView.colorInfos.count],
//                       cardViewItem: self.cardViewItems[idx],
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
  static let colorInfos: [BaseCardView.ColorInfo] =
    [.init(gradientStartColor: .materialRed800,
           gradientEndColor: .materialRed800,
           shadowColor: .materialRed800),
     .init(gradientStartColor: .materialPink800,
           gradientEndColor: .materialPink800,
           shadowColor: .materialPink800),
     .init(gradientStartColor: .materialPurple800,
           gradientEndColor: .materialPurple800,
           shadowColor: .materialPurple800),
     .init(gradientStartColor: .materialDeepPurple800,
           gradientEndColor: .materialDeepPurple800,
           shadowColor: .materialDeepPurple800),
     .init(gradientStartColor: .materialIndigo800,
           gradientEndColor: .materialIndigo800,
           shadowColor: .materialIndigo800),
     .init(gradientStartColor: .materialBlue800,
           gradientEndColor: .materialBlue800,
           shadowColor: .materialBlue800),
     .init(gradientStartColor: .materialLightBlue800,
           gradientEndColor: .materialLightBlue800,
           shadowColor: .materialLightBlue800),
     .init(gradientStartColor: .materialTeal800,
           gradientEndColor: .materialTeal800,
           shadowColor: .materialTeal800),
     .init(gradientStartColor: .materialGreen800,
           gradientEndColor: .materialGreen800,
           shadowColor: .materialGreen800),
     .init(gradientStartColor: .materialBrown800,
           gradientEndColor: .materialBrown800,
           shadowColor: .materialBrown800),
     .init(gradientStartColor: .materialGrey800,
           gradientEndColor: .materialGrey800,
           shadowColor: .materialGrey800),
    ].shuffled()
}

struct CardListView_Previews: PreviewProvider {
  static var previews: some View {
    CardListView(cardViewItems: MockProvider.cardViewItems)
  }
}

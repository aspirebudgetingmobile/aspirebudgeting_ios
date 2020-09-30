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
    [.init(gradientStartColor: .cinnamonSatin,
           gradientEndColor: .cinnamonSatin,
           shadowColor: .cinnamonSatin),
     .init(gradientStartColor: .camel,
           gradientEndColor: .camel,
           shadowColor: .camel),
     .init(gradientStartColor: .darkElectricBlue,
           gradientEndColor: .darkElectricBlue,
           shadowColor: .darkElectricBlue),
     .init(gradientStartColor: .keppel,
           gradientEndColor: .keppel,
           shadowColor: .keppel),
     .init(gradientStartColor: .copperRed,
           gradientEndColor: .copperRed,
           shadowColor: .copperRed),
     .init(gradientStartColor: .forestGreenCrayola,
           gradientEndColor: .forestGreenCrayola,
           shadowColor: .forestGreenCrayola),
     .init(gradientStartColor: .antiqueBrass,
           gradientEndColor: .antiqueBrass,
           shadowColor: .antiqueBrass),
     .init(gradientStartColor: .darkCornflowerBlue,
           gradientEndColor: .darkCornflowerBlue,
           shadowColor: .darkCornflowerBlue),
     .init(gradientStartColor: .hookersGreen,
           gradientEndColor: .hookersGreen,
           shadowColor: .hookersGreen),
     .init(gradientStartColor: .middleBluePurple,
           gradientEndColor: .middleBluePurple,
           shadowColor: .middleBluePurple),
     .init(gradientStartColor: .redwood,
           gradientEndColor: .redwood,
           shadowColor: .redwood),
    ].shuffled()
}

struct CardListView_Previews: PreviewProvider {
  static var previews: some View {
    CardListView(cardViewItems: MockProvider.cardViewItems)
  }
}

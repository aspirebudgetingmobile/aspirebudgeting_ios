//
//  CardListView.swift
//  Aspire Budgeting
//

import SwiftUI

struct CardListView: View {

  let cardViewItems: [BaseCardView<DashboardCardView>.CardViewItem]

  var body: some View {
    GeometryReader {g in
      ScrollView {
        VStack {
          ForEach(0..<self.cardViewItems.count) { idx in
            GeometryReader { geo in
              BaseCardView<DashboardCardView>(
//                       cardViewItem: self.cardViewItems[idx],
                       minY: g.frame(in: .global).minY,
                       curY: geo.frame(in: .global).minY,
                baseColor: CardListView.baseColors[idx % CardListView.baseColors.count]) {
                DashboardCardView(cardViewItem: self.cardViewItems[idx],
                                  baseColor: CardListView.baseColors[idx % CardListView.baseColors.count])
              }
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
  static let baseColors: [Color] =
    [.materialRed800,
     .materialPink800,
     .materialPurple800,
     .materialDeepPurple800,
     .materialIndigo800,
     .materialBlue800,
     .materialLightBlue800,
     .materialTeal800,
     .materialGreen800,
     .materialBrown800,
     .materialGrey800,
    ].shuffled()
}

struct CardListView_Previews: PreviewProvider {
  static var previews: some View {
    CardListView(cardViewItems: MockProvider.cardViewItems)
  }
}

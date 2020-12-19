//
//  DashboardCardsListView.swift
//  Aspire Budgeting
//

import SwiftUI

struct DashboardCardsListView: View {

  let cardViewItems: [DashboardCardView.DashboardCardItem]

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
                baseColor: colorFor(idx: idx)) {
                DashboardCardView(cardViewItem: self.cardViewItems[idx],
                                  baseColor: colorFor(idx: idx))
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

//MARK:- Internal Types
extension DashboardCardsListView {
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

  private func colorFor(idx: Int) -> Color {
    DashboardCardsListView
      .baseColors[idx % DashboardCardsListView.baseColors.count]
  }
}

struct CardListView_Previews: PreviewProvider {
  static var previews: some View {
    DashboardCardsListView(cardViewItems: MockProvider.cardViewItems)
  }
}

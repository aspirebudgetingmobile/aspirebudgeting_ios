//
// CardExpandedView.swift
// Aspire Budgeting
//

import SwiftUI

struct CardExpandedView: View {

  let cardDetails: CardDetails

  private let bannerHeight: CGFloat = 100
  private let cornerRadius: CGFloat = 24

    var body: some View {
      VStack {
        banner
        details
      }

    }
}

extension CardExpandedView {
  private var banner: some View {
    ZStack {
      Rectangle()
        .fill(cardDetails.bannerGradient)
        .frame(height: bannerHeight)
      Text(cardDetails.title)
        .font(.nunitoBold(size: 22))
        .foregroundColor(.white)
    }
  }

  private var totals: some View {
    HStack(spacing: 30) {

      CardTotalsView(title: "Budgeted",
                     amount: cardDetails.budgetedTotal,
                     startColor: .greenFondStartColor,
                     endColor: .greenFondEndColor,
                     shadowColor: .greenFondShadowColor,
                     graphImage: .minigraphUp)
        .frame(width: 160, height: 80)

      CardTotalsView(title: "Spent",
                     amount: cardDetails.spentTotal,
                     startColor: .redPinkFondStartColor,
                     endColor: .redPinkFondEndColor,
                     shadowColor: .redPinkFondShadowColor,
                     graphImage: .minigraphDown)
        .frame(width: 160, height: 80)

    }
  }

  private var details: some View {
    ZStack(alignment: .top) {
      Rectangle()
        .fill(Color.primaryBackgroundColor)
        .cornerRadius(cornerRadius)
        .padding(.top, -25)
        .shadow(radius: 10)
        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)

      totals
    }
  }
}

extension CardExpandedView {
  struct CardDetails {
    let title: String
    let bannerGradient: LinearGradient
    let budgetedTotal: String
    let spentTotal: String
  }
}
struct CardExpandedView_Previews: PreviewProvider {
  static var cardDetils: CardExpandedView.CardDetails {
    let title = "Investments"
    let bannerGradient = LinearGradient(gradient:
                                          Gradient(colors: [.blueFondStartColor,
                                                            .blueFondEndColor,
                                          ]),
                                        startPoint: UnitPoint(x: 0.5, y: -0.48),
                                        endPoint: UnitPoint(x: -0.46, y: 0.52))

    let details = CardExpandedView.CardDetails(title: title,
                                               bannerGradient: bannerGradient,
                                               budgetedTotal: "$500",
                                               spentTotal: "$30")

    return details
  }
    static var previews: some View {
      CardExpandedView(cardDetails: CardExpandedView_Previews.cardDetils)
    }
}

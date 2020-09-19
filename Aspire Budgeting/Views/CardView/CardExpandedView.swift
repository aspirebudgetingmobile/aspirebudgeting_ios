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
  private func createGraddient(startColor: Color,
                               endColor: Color) -> LinearGradient {
    let startColor = Gradient.Stop(color: startColor, location: 0)

    let endColor = Gradient.Stop(color: endColor, location: 1)

    let startPoint = UnitPoint(x: 0.5, y: -0.48)

    let endPoint = UnitPoint(x: -0.46, y: 0.52)

    let gradient = Gradient(stops: [startColor, endColor])
    return LinearGradient(gradient: gradient, startPoint: startPoint, endPoint: endPoint)
  }

  private func totalsView(title: String,
                          amount: String,
                          startColor: Color,
                          endColor: Color,
                          shadowColor: Color,
                          graphImage: Image) -> some View {
    ZStack {
      Rectangle()
        .fill(createGraddient(startColor: startColor, endColor: endColor))
        .cornerRadius(10)
        .shadow(color: shadowColor, radius: 2, x: 0, y: 0)

      VStack(alignment: .leading) {
        HStack {
          Text(title)
            .font(.karlaRegular(size: 16))
            .foregroundColor(.white)
            .padding(.leading)
          Spacer()
          graphImage
            .padding(.trailing)
            .foregroundColor(.white)
        }

        Text(amount)
          .padding(.leading)
          .font(.karlaBold(size: 20))
          .foregroundColor(.white)

        Text("accross all categories below")
          .padding(.leading)
          .font(.karlaRegular(size: 10))
          .foregroundColor(.white)
      }
    }.frame(width: 160, height: 80)
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
      totalsView(title: "Budgeted",
                 amount: cardDetails.budgetedTotal,
                 startColor: .greenFondStartColor,
                 endColor: .greenFondEndColor,
                 shadowColor: .greenFondShadowColor,
                 graphImage: .minigraphUp)

      totalsView(title: "Spent",
                 amount: cardDetails.spentTotal,
                 startColor: .redPinkFondStartColor,
                 endColor: .redPinkFondEndColor,
                 shadowColor: .redPinkFondShadowColor,
                 graphImage: .minigraphDown)

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
                                                            .blueFondEndColor]),
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

//
// CategoryDetailsView.swift
// Aspire Budgeting
//

import SwiftUI

struct CategoryDetailsView: View {

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

extension CategoryDetailsView {
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

      CardTotalsView(title: "Available",
                     amount: cardDetails.availableTotal)
        .frame(width: 160, height: 80)

      CardTotalsView(title: "Spent",
                     amount: cardDetails.spentTotal)
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

      VStack {
        totals

        Divider()
          .padding([.top, .horizontal])

        Text("Budget per category")
          .font(.karlaBold(size: 18))
          .foregroundColor(.secondaryTextColor)

        CategoryListView(categories: cardDetails.categories,
                         tintColor: cardDetails.tintColor)
      }

    }
  }
}

extension CategoryDetailsView {
  struct CardDetails {
    let title: String
    let bannerGradient: LinearGradient
    let budgetedTotal: AspireNumber
    let spentTotal: AspireNumber
    let availableTotal: AspireNumber
    let categories: [Category]
    let tintColor: Color
  }
}
struct CardExpandedView_Previews: PreviewProvider {
  static var cardDetils: CategoryDetailsView.CardDetails {
    let title = "Investments"
    let bannerGradient = LinearGradient(gradient:
                                          Gradient(colors: [.middleBluePurple,
                                                            .middleBluePurple,
                                          ]),
                                        startPoint: UnitPoint(x: 0.5, y: -0.48),
                                        endPoint: UnitPoint(x: -0.46, y: 0.52))

    let details = CategoryDetailsView
        .CardDetails(title: title,
                     bannerGradient: bannerGradient,
                     budgetedTotal: AspireNumber(stringValue: "$500"),
                     spentTotal: AspireNumber(stringValue: "-$30"),
                     availableTotal: AspireNumber(stringValue: "40"),
                     categories: MockProvider
                      .cardViewItems[0]
                      .categories,
                     tintColor: .keppel)

    return details
  }
    static var previews: some View {
      CategoryDetailsView(cardDetails: CardExpandedView_Previews.cardDetils)
    }
}

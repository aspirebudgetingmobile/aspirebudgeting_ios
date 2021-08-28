//
//  DashboardCardView.swift
//  Aspire Budgeting
//

import SwiftUI

struct DashboardCardView: View {

  let cardViewItem: DashboardCardItem
  let baseColor: Color
  @State private var showDetails = false

  private var expandedDetails: CategoryDetailsView.CardDetails {
    CategoryDetailsView
      .CardDetails(title: cardViewItem.title,
                   baseColor: baseColor,
                   budgetedTotal: cardViewItem.budgetedTotal,
                   spentTotal: cardViewItem.spentTotal,
                   availableTotal: cardViewItem.availableTotal,
                   categories: cardViewItem.categories,
                   tintColor: baseColor)
  }

  var body: some View {
    VStack(alignment: .leading) {
      topRow
      secondRow
      progressBar
      fourthRow
    }.sheet(isPresented: $showDetails) {
      CategoryDetailsView(cardDetails: self.expandedDetails)
    }
  }
}

extension DashboardCardView {
  private var topRow: some View {
    HStack {
      ZStack {
        Circle()
          .fill(Color.white)
          .opacity(0.2)
          .frame(width: 32, height: 32)

        Image("moneyBag")
      }.padding(.horizontal, 10)

      Text(cardViewItem.title)
        .font(.nunitoBold(size: 18))
        .foregroundColor(.white)

      Spacer()

      Button(action: {
        self.showDetails.toggle()
      }, label: {
        Text("Details >")
          .font(.karlaRegular(size: 12))
          .lineSpacing(3)
          .foregroundColor(.white)
          .overlay(
            RoundedRectangle(cornerRadius: 14)
              .stroke(Color.white, lineWidth: 1)
              .frame(width: 79, height: 28)
          )
          .padding()
          .padding(.trailing)
      })

    }.padding(.top, 5)
  }

  private var secondRow: some View {
    HStack {
      Text("AVAILABLE")
        .foregroundColor(.white)
        .font(.nunitoRegular(size: 13))
        .lineSpacing(3)
        .padding(.horizontal, 10)

      Spacer()

      Text("BUDGETED")
        .foregroundColor(.white)
        .font(.nunitoRegular(size: 13))
        .lineSpacing(3)
        .padding(.trailing)
    }
  }

  private var progressBar: some View {
    AspireProgressBar(barType: .detailed,
                      shadowColor: baseColor,
                      tintColor: baseColor,
                      progressFactor: self.cardViewItem.progressFactor)
      .padding(.horizontal, 10)
  }

  private var fourthRow: some View {
    HStack {
      Text(self.cardViewItem.availableTotal.stringValue)
        .foregroundColor(.white)
        .font(.nunitoRegular(size: 13))
        .lineSpacing(3)
        .padding(.horizontal, 10)

      Spacer()

      Text(self.cardViewItem.budgetedTotal.stringValue)
        .foregroundColor(.white)
        .font(.nunitoRegular(size: 13))
        .lineSpacing(3)
        .padding(.trailing)
    }
  }
}

// MARK: - Internal Types
extension DashboardCardView {
  struct DashboardCardItem: Equatable {
    let title: String
    let availableTotal: AspireNumber
    let budgetedTotal: AspireNumber
    let spentTotal: AspireNumber
    let progressFactor: Double
    let categories: [DashboardCategory]
  }
}

struct DashboardCardView_Previews: PreviewProvider {
  static var previews: some View {
    DashboardCardView(cardViewItem:
                        DashboardCardView.DashboardCardItem(
                          title: "Investments",
                          availableTotal: AspireNumber(stringValue: "$50"),
                          budgetedTotal: AspireNumber(stringValue: "$40"),
                          spentTotal: AspireNumber(stringValue: "$30"),
                          progressFactor: 0.5,
                          categories: [DashboardCategory.init(row: ["$1",
                                                           "$1",
                                                           "$1",
                                                           "$1",
                                                           "$1",
                                                           "$1",
                                                           "$1",
                                                           "$1",
                                                           "$1",
                                                           "$1",
                          ]),
                          ]),
                      baseColor: .materialTeal800)
  }
}

//
//  CardView.swift
//  Aspire Budgeting
//

import SwiftUI

struct CardView: View {

  let colorInfo: ColorInfo
  let cardViewItem: CardViewItem
  var minY: CGFloat = 0
  var curY: CGFloat = 0

  @State private var showDetails = false

  private let cornerRadius: CGFloat = 24
  private let height: CGFloat = 163

  private let shadowRadius: CGFloat = 14
  private let shadowYOffset: CGFloat = 4

  private var gradient: LinearGradient {
    Color.fondGradientFrom(startColor: colorInfo.gradientStartColor,
                           endColor: colorInfo.gradientEndColor)
  }

  private var offsetY: CGFloat {
    curY < minY ? minY - curY : 0
  }

  private var expandedDetails: CategoryDetailsView.CardDetails {
    CategoryDetailsView
        .CardDetails(title: cardViewItem.title,
                     bannerGradient: gradient,
                     budgetedTotal: cardViewItem.budgetedTotal,
                     spentTotal: cardViewItem.spentTotal,
                     availableTotal: cardViewItem.availableTotal,
                     categories: cardViewItem.categories,
                     tintColor: colorInfo.gradientEndColor)
  }

  var body: some View {
    ZStack(alignment: .top) {
      containerBox
      VStack(alignment: .leading) {
        topRow
        secondRow
        progressBar
        fourthRow
      }.sheet(isPresented: $showDetails) {
        CategoryDetailsView(cardDetails: self.expandedDetails)
      }
    }
    .offset(y: offsetY)
  }
}

extension CardView {
  private var containerBox: some View {
    Rectangle()
      .fill(gradient)
      .cornerRadius(cornerRadius)
      .frame(height: height)
  }

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
                      shadowColor: self.colorInfo.shadowColor,
                      tintColor: self.colorInfo.gradientEndColor,
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
extension CardView {
  struct ColorInfo {
    let gradientStartColor: Color
    let gradientEndColor: Color
    let shadowColor: Color
  }

  struct CardViewItem {
    let title: String
    let availableTotal: AspireNumber
    let budgetedTotal: AspireNumber
    let spentTotal: AspireNumber
    let progressFactor: Double
    let categories: [Category]
  }
}

// MARK: - Previews
struct CardView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      Group {
        CardView(colorInfo: .init(gradientStartColor: .materialBrown800,
                                  gradientEndColor: .materialBrown800,
                                  shadowColor: .materialBrown800),
                 cardViewItem: MockProvider.cardViewItems[0])

        CardView(colorInfo: .init(gradientStartColor: .materialDeepPurple800,
                                  gradientEndColor: .materialDeepPurple800,
                                  shadowColor: .materialDeepPurple800),
                 cardViewItem: MockProvider.cardViewItems[1])
      }
    }
  }
}

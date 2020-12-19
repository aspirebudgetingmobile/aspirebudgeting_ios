//
//  DashboardCardView.swift
//  Aspire Budgeting
//

import SwiftUI

struct DashboardCardView: View {

  let cardViewItem: BaseCardView<DashboardCardView>.CardViewItem
  let colorInfo: BaseCardView<DashboardCardView>.ColorInfo

  private var gradient: LinearGradient {
    Color.fondGradientFrom(startColor: colorInfo.gradientStartColor,
                           endColor: colorInfo.gradientEndColor)
  }
  
  @State private var showDetails = false

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

// struct DashboardCardVIew_Previews: PreviewProvider {
//    static var previews: some View {
//        DashboardCardVIew()
//    }
// }

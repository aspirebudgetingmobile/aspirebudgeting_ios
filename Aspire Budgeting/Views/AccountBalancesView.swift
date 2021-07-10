//
//  AccountBalancesView.swift
//  Aspire Budgeting
//

import SwiftUI

struct AccountBalancesView: View {
  let viewModel: AccountBalancesViewModel

  func getColorForNumber(number: AspireNumber) -> Color {
    if number.isNegative {
      return Color(red: 0.784, green: 0.416, blue: 0.412)
    }
    return Color(red: 0.196, green: 0.682, blue: 0.482)
  }

  var body: some View {
    ZStack { // TODO: ZStack is probably not needed.
      if viewModel.error == nil {
        if let accountBalances = viewModel.dataProvider?.accountBalances {
          ScrollView {
            ForEach(
              accountBalances.accountBalances,
              id: \.self
            ) { accountBalance in
              BaseCardView(minY: 0, curY: 0, baseColor: .accountBalanceCardColor) {
                GeometryReader { geo in
                  ZStack {
                    Image.bankIcon
                      .resizable()
                      .scaledToFit()
                      .frame(width: geo.frame(in: .global).width,
                             height: geo.frame(in: .global).height,
                             alignment: .center)

                    VStack {
                      Text(accountBalance.accountName)
                        .foregroundColor(Color.white)
                        .font(.nunitoSemiBold(size: 20))

                      Text(accountBalance.balance.stringValue)
                        .foregroundColor(self.getColorForNumber(number: accountBalance.balance))
                        .font(.nunitoSemiBold(size: 25))

                      Text(accountBalance.additionalText)
                        .foregroundColor(Color.white)
                        .font(.nunitoRegular(size: 12))
                    }
                  }
                }
              }
              .padding(.horizontal)
            }
          }
        } else {
          GeometryReader { geo in
            LoadingView(height: geo.frame(in: .local).size.height)
          }
        }
      } else {
        ZStack {
          Rectangle().foregroundColor(Colors.aspireGray).edgesIgnoringSafeArea(.all)
          ErrorBannerView(error: viewModel.error!)
        }
      }
    }
    .background(Color.primaryBackgroundColor)
    .onAppear {
      self.viewModel.refresh()
    }
  }
}

// struct AccountBalancesView_Previews: PreviewProvider {
//  static var previews: some View {
//    AccountBalancesView(viewModel: <#AccountBalancesViewModel#>)
//  }
// }

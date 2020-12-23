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
    ZStack { //TODO: ZStack is probably not needed.
      if viewModel.error == nil {
        if viewModel.accountBalances != nil {
          List {
            ForEach(
              viewModel.accountBalances!,
              id: \.self
            ) { accountBalance in
              VStack(alignment: .leading) {
                Text(accountBalance.accountName)
                  .foregroundColor(Color.white)
                  .font(.nunitoSemiBold(size: 20))

                ZStack {
                  Rectangle()
                    .foregroundColor(Color(red: 0.769, green: 0.769, blue: 0.769))
                    .frame(height: 50)
                    .cornerRadius(10)
                    .overlay(
                      RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(red: 0.679, green: 0.674, blue: 0.674), lineWidth: 5)
                    )

                  Text(accountBalance.balance.stringValue)
                    .padding(.horizontal)
                    .foregroundColor(self.getColorForNumber(number: accountBalance.balance))
                    .font(.nunitoSemiBold(size: 25))
                    .frame(maxWidth: .infinity, alignment: .leading)
                }.padding(.top, -10)
              }
            }.background(Colors.aspireGray)
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

//struct AccountBalancesView_Previews: PreviewProvider {
//  static var previews: some View {
//    AccountBalancesView(viewModel: <#AccountBalancesViewModel#>)
//  }
//}

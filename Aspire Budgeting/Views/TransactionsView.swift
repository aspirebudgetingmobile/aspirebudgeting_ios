//
// TransactionsView.swift
// Aspire Budgeting
//

import SwiftUI

struct TransactionsView: View {
  let viewModel: TransactionsViewModel

  var body: some View {
    VStack {
      if viewModel.error == nil {
        if let transactions = viewModel.dataProvider?.transactions.transactions {
          List {
            ForEach(transactions.reversed(), id: \.self) { transaction in
              HStack {
                Image("moneyBag")
                VStack(alignment: .leading) {
                  Text(transaction.category)
                    .font(.nunitoBold(size: 16))
                  Text(transaction.date.description)
                    .font(.karlaRegular(size: 14))
                  Text(transaction.account)
                    .font(.karlaRegular(size: 14))
                  if transaction.approvalType == .pending {
                    Text("Pending")
                      .font(.karlaRegular(size: 14))
                  }
                  if transaction.approvalType == .approved {
                    Text("Approved")
                      .font(.karlaRegular(size: 14))
                  }
                }
                Spacer()
                Text(transaction.amount)
                  .font(.nunitoBold(size: 16))
              }
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
    .onAppear {
      self.viewModel.refresh()
    }
  }
}

//struct TransactionsView_Previews: PreviewProvider {
//    static var previews: some View {
//        TransactionsView()
//    }
//}

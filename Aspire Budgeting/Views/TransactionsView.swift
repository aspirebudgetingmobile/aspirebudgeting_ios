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
              VStack {
                HStack {
                  Text(transaction.date.description)
                  Text(transaction.category)
                  Text(transaction.amount)
                }
                HStack {
                  Text(transaction.memo)
                }
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

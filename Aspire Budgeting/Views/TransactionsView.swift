//
// TransactionsView.swift
// Aspire Budgeting
//

import SwiftUI

struct TransactionsView: View {

  @ObservedObject var viewModel: TransactionsViewModel
  @State private var searchText = ""
  @State private(set) var showingAlert = false

  var body: some View {
    VStack {
      if self.viewModel.isLoading {
        GeometryReader { geo in
          LoadingView(height: geo.frame(in: .local).size.height)
        }
      } else {
        searchBar
        List {
          ForEach(viewModel.filtered(by: searchText).reversed(), id: \.self) { transaction in
            HStack {
              arrowFor(type: transaction.transactionType)
              VStack(alignment: .leading) {
                Text(transaction.category)
                  .font(.nunitoBold(size: 16))
                Text(viewModel.formattedDate(for: transaction.date))
                  .font(.karlaRegular(size: 14))
                if !transaction.memo.isEmpty {
                  Text(transaction.memo)
                    .font(.karlaRegular(size: 14))
                }
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
                .foregroundColor(
                  transaction.transactionType == .inflow ? .expenseGreen : .expenseRed
                )
            }
          }.listRowBackground(Color.primaryBackgroundColor)
        }
      }
    }
    .alert(isPresented: $showingAlert, content: {
      Alert(title: Text("Error Occured"),
            message: Text("\(viewModel.error?.localizedDescription ?? "")"),
            dismissButton: .cancel())
    })
    .onReceive(viewModel.$error, perform: { error in
      self.showingAlert = error != nil
    })
    .onAppear {
      self.viewModel.refresh()
    }
  }
}

extension TransactionsView {
  private var searchBar: some View {
    SearchBar(text: $searchText)
      .ignoreKeyboard()
  }

  private var arrowDown: some View {
    Image(systemName: "arrow.down.circle")
      .foregroundColor(.expenseGreen)
  }

  private var arrowUp: some View {
    Image(systemName: "arrow.up.circle")
      .foregroundColor(.expenseRed)
  }

  private func arrowFor(type: TransactionType) -> AnyView {
    switch type {
    case .inflow:
      return AnyView(arrowDown)
    case .outflow:
      return AnyView(arrowUp)
    }
  }
}

// struct TransactionsView_Previews: PreviewProvider {
//    static var previews: some View {
//        TransactionsView()
//    }
// }

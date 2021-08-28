//
// CategoryTransferView.swift
// Aspire Budgeting
//

import SwiftUI

struct CategoryTransferView: View {
  @ObservedObject var viewModel: CategoryTransferViewModel
  
  @State private var amountString = ""
  @State private var memoString = ""
  @State private var fromCategory = -1
  @State private var toCategory = -1
  @State private var showSuccessAlert = false
  @State private var showError = false

  let alertText = "Category Transfer submitted"

  var showAddButton: Bool {
    !amountString.isEmpty &&
      fromCategory != -1 &&
      toCategory != -1
  }

  var body: some View {
    Form {
      AspireTextField(
        text: $amountString,
        placeHolder: "Amount",
        keyboardType: .decimalPad,
        leftImage: Image.bankNote
      )

      AspireTextField(
        text: $memoString,
        placeHolder: "Memo",
        keyboardType: .default,
        leftImage: Image.scribble
      )

      if self.viewModel.categories != nil {
        Picker(
          selection: $fromCategory,
          label: HStack {
            Image.envelope
              .resizable()
              .scaledToFit()
              .frame(width: 30, height: 30, alignment: .center)
            Text("From Category")
              .font(.nunitoSemiBold(size: 20))
          }
        ) {
          ForEach(0..<self.viewModel.categories!.categories.count) {
            Text(self.viewModel.categories!.categories[$0].title)
          }.navigationBarTitle(Text("From Category"))
        }
        
        Picker(
          selection: $toCategory,
          label: HStack {
            Image.envelope
              .resizable()
              .scaledToFit()
              .frame(width: 30, height: 30, alignment: .center)
            Text("To Category")
              .font(.nunitoSemiBold(size: 20))
          }
        ) {
          ForEach(0..<self.viewModel.categories!.categories.count) {
            Text(self.viewModel.categories!.categories[$0].title)
          }.navigationBarTitle(Text("To Category"))
        }
      }
      
      if showAddButton {
        Button(action: {
          let categorytransfer = CategoryTransfer(
            amount: amountString,
            fromCategory: self.viewModel.categories!.categories[fromCategory],
            toCategory: self.viewModel.categories!.categories[toCategory],
            memo: memoString)
          self.viewModel.submit(categoryTransfer: categorytransfer)
        }, label: {
          Text("Transfer")
        })
        .alert(isPresented: $showSuccessAlert) {
          Alert(title: Text(alertText))
        }
        .alert(isPresented: $showError) {
          Alert(title: Text("Error Occured"),
                message: Text("\(viewModel.error?.localizedDescription ?? "")"),
                dismissButton: .cancel())
        }
      }
    }
    .onAppear { viewModel.getCategories() }
    .onReceive(viewModel.$signal, perform: { signal in
      self.showSuccessAlert = signal != nil
    })
    .onReceive(viewModel.$error, perform: { error in
      self.showError = error != nil

    })
    .navigationBarTitle("Category Transfer")
  }
}

//struct CategoryTransferView_Previews: PreviewProvider {
//    static var previews: some View {
//        CategoryTransferView()
//    }
//}

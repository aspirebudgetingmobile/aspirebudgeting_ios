//
// CategoryTransferView.swift
// Aspire Budgeting
//

import SwiftUI

struct CategoryTransferView: View {
  let viewModel: CategoryTransferViewModel

  @State private var amountString = ""
    var body: some View {
      Form {
        AspireTextField(
          text: $amountString,
          placeHolder: "Amount",
          keyboardType: .decimalPad,
          leftImage: Image.bankNote
        )
      }
      .navigationBarTitle("Category Transfer")
    }
}

//struct CategoryTransferView_Previews: PreviewProvider {
//    static var previews: some View {
//        CategoryTransferView()
//    }
//}

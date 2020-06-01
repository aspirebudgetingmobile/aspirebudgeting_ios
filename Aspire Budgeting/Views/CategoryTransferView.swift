//
// CategoryTransferView.swift
// Aspire Budgeting
//

import SwiftUI

struct CategoryTransferView: View {
  @EnvironmentObject var sheetsManager: GoogleSheetsManager
  @State private var fromCategory: String
  @State private var memoString = ""

  @State private var toCategorySelected = false
  @State private var selectedToCategory = 0
  @State private var showToCategoriesPicker = false
  
  @State private var showingAlert = false
  
  @State private var transactionAdded = false
  
  @State private var amountString = ""

  init(fromCategory: String) {
    self._fromCategory = State(initialValue: fromCategory)
  }

  func getToCategory() -> String {
    return self.toCategorySelected ? self.sheetsManager.transactionCategories![self.selectedToCategory] : "To"
  }
    var body: some View {
      ScrollView {
        AspireTextField(text: $fromCategory,
                        placeHolder: "",
                        imageName: "categories_icon",
                        keyboardType: .default,
                        disabled: true)

        AspirePickerButton(title: getToCategory(), imageName: "categories_icon") {
          self.toCategorySelected = true
          self.showToCategoriesPicker.toggle()
        }
        if self.showToCategoriesPicker {
          Picker(selection: $selectedToCategory, label: Text("")) {
            ForEach(0..<self.sheetsManager.transactionCategories!.count) {
              Text(self.sheetsManager.transactionCategories![$0])
                .foregroundColor(.white)
            }
          }
        }
        
        AspireTextField(
          text: $amountString,
          placeHolder: "Enter Amount",
          imageName: "dollar_icon",
          keyboardType: .decimalPad
        )
        
        AspireTextField(
          text: $memoString,
          placeHolder: "Add Memo",
          imageName: "memo_icon",
          keyboardType: .default
        )
        
        AspireButton(title: "Add", type: .green) {
          if !self.amountString.isEmpty && self.toCategorySelected {
            self.sheetsManager.addCategoryTransfer(
              from: self.fromCategory,
              to: self.sheetsManager.transactionCategories![self.selectedToCategory],
              amount: self.amountString,
              memo: self.memoString) { result in
                self.transactionAdded = result
                self.showingAlert = true
            }
          }
        }.padding().alert(isPresented: $showingAlert) { () -> Alert in
          if self.transactionAdded {
            return Alert(title: Text("Transfer added"))
          } else {
            return Alert(title: Text("An error occured. Please try again."))
          }
        }
      }.background(Colors.aspireGray)
        .edgesIgnoringSafeArea(.all)
  }
}

//struct CategoryTransferView_Previews: PreviewProvider {
//    static var previews: some View {
//        CategoryTransferView()
//    }
//}

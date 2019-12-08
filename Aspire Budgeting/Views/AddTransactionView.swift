//
//  AddTransactionView.swift
//  Aspire Budgeting
//
//  Created by TeraMo Labs on 12/8/19.
//  Copyright © 2019 TeraMo Labs. All rights reserved.
//

import SwiftUI

struct AddTransactionView: View {
  @EnvironmentObject var sheetsManager: GoogleSheetsManager
  
  @State private var amountString = ""
  @State private var date = Date()
  @State private var category = ""
  
    var body: some View {
      Form {
        Section(header: Text("")) {
          TextField("Enter Amount", text: $amountString).keyboardType(.decimalPad).textFieldStyle(RoundedBorderTextFieldStyle())
        }
        Section(header: Text("")) {
          DatePicker(selection: $date, in: ...Date(), displayedComponents: .date) {
            Text("Enter Date")
            }.foregroundColor(.white)
        }
        Section(header: Text("")) {
          Picker(selection: $category, label: Text("Select Category")) {
            ForEach(0 ..< self.sheetsManager.transactionCategories!.count) {
              Text(self.sheetsManager.transactionCategories![$0])
            }
          }.foregroundColor(.white)
        }
      }.background(Colors.aspireGray).edgesIgnoringSafeArea(.all)
  }
}

//struct AddTransactionView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddTransactionView()
//    }
//}

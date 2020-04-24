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
  
  var dateFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    return formatter
  }
  
  @State private var amountString = ""
  @State private var memoString = ""
  
  @State private var showDatePicker = false
  @State private var selectedDate = Date()
  @State private var dateSelected = false
  
  @State private var showCategoriesPicker = false
  @State private var categorySelected = false
  @State private var selectedCategory = 0
  
  @State private var showAccountPicker = false
  @State private var accountSelected = false
  @State private var selectedAccount = 0
  
  @State private var transactionType = 0
  @State private var approvalType = 0
  
  @State private var showingAlert = false
  @State private var transactionAdded = false
  
  func getDateString() -> String {
    return dateSelected ? dateFormatter.string(from: selectedDate) : "Select Date"
  }
  
  func getSelectedCategory() -> String {
    return categorySelected ? self.sheetsManager.transactionCategories![selectedCategory]: "Select Category"
  }
  
  func getSelectedAccount() -> String {
    return accountSelected ? self.sheetsManager.transactionAccounts![selectedAccount] : "Select Account"
  }
  
  var body: some View {
    ScrollView {
      Group {
        AspireTextField(text: $amountString,
                        placeHolder: "Enter Amount",
                        imageName: "dollar_icon",
                        keyboardType: .decimalPad)

        AspireTextField(text: $memoString,
                        placeHolder: "Add Memo",
                        imageName: "memo_icon",
                        keyboardType: .default)
      }
      
      AspirePickerButton(title: getDateString(), imageName: "calendar_icon") {
        withAnimation {
          self.dateSelected = true
          self.showDatePicker.toggle()
          print(self.selectedDate)
        }
      }
      if showDatePicker {
        DatePicker(selection: $selectedDate, in: ...Date(), displayedComponents: .date) {
          Text("")
        }.foregroundColor(Color.white)
      }
      
      AspirePickerButton(title: getSelectedCategory(), imageName: "categories_icon") {
        withAnimation {
          self.categorySelected = true
          self.showCategoriesPicker.toggle()
        }
      }.disabled(self.sheetsManager.transactionCategories == nil)
      if showCategoriesPicker {
        Picker(selection: $selectedCategory, label: Text("")) {
          ForEach(0..<self.sheetsManager.transactionCategories!.count) {
            Text(self.sheetsManager.transactionCategories![$0]).foregroundColor(.white)
          }
        }
      }
      
      AspirePickerButton(title: getSelectedAccount(), imageName: "accounts_icon") {
        withAnimation {
          self.accountSelected = true
          self.showAccountPicker.toggle()
        }
      }.disabled(self.sheetsManager.transactionAccounts == nil)
      if showAccountPicker {
        Picker(selection: $selectedAccount, label: Text("")) {
          ForEach(0..<self.sheetsManager.transactionAccounts!.count) {
            Text(self.sheetsManager.transactionAccounts![$0]).foregroundColor(.white)
          }
        }
      }
      
      Picker(selection: $transactionType, label: Text("")) {
        Text("Inflow").tag(0)
        Text("Outflow").tag(1)
      }.pickerStyle(SegmentedPickerStyle()).padding()
      
      Picker(selection: $approvalType, label: Text("")) {
        Text("Approved").tag(0)
        Text("Pending").tag(1)
      }.pickerStyle(SegmentedPickerStyle()).padding()
      
      AspireButton(title: "Add", type: .red) {
        if self.amountString != "" &&
          self.dateSelected &&
          self.categorySelected &&
          self.accountSelected {
          self.sheetsManager.addTransaction(amount: self.amountString,memo: self.memoString, date: self.selectedDate, category: self.selectedCategory, account: self.selectedAccount, transactionType: self.transactionType, approvalType: self.approvalType) { result in
            self.transactionAdded = result
            self.showingAlert = true
          }
        }
      }.padding().alert(isPresented: $showingAlert) { () -> Alert in
        if self.transactionAdded {
          return Alert(title: Text("Transaction added"))
        } else {
          return Alert(title: Text("An error occured. Please try again."))
        }
      }
    }.background(Colors.aspireGray)
      .edgesIgnoringSafeArea(.all)
      .onTapGesture {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
  }
}

//struct AddTransactionView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddTransactionView()
//    }
//}

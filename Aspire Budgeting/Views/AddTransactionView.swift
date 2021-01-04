//
//  AddTransactionView.swift
//  Aspire Budgeting
//

import SwiftUI

struct AddTransactionView: View {
  let viewModel: AddTransactionViewModel
  var dateFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    return formatter
  }

  @State private var amountString = ""
  @State private var memoString = ""

//  @State private var showDatePicker = false
  @State private var selectedDate = Date()
//  @State private var dateSelected = false

//  @State private var showCategoriesPicker = false
//  @State private var categorySelected = false
  @State private var selectedCategory = -1
//
//  @State private var showAccountPicker = false
//  @State private var accountSelected = false
  @State private var selectedAccount = -1
//
  @State private var transactionType = -1
  @State private var approvalType = -1
//
//  @State private var showingAlert = false
//  @State private var transactionAdded = false
//

  var showAddButton: Bool {
    !amountString.isEmpty &&
      selectedCategory != -1 &&
      selectedAccount != -1 &&
      transactionType != -1 &&
      approvalType != -1
  }

  func getDateString() -> String {
    self.dateFormatter.string(from: self.selectedDate)
  }
//
//  func getSelectedCategory() -> String {
//    self.categorySelected
//      ? self.sheetsManager.transactionCategories![self.selectedCategory]
//      : "Select Category"
//  }
//
//  func getSelectedAccount() -> String {
//    self.accountSelected
//      ? self.sheetsManager.transactionAccounts![self.selectedAccount]
//      : "Select Account"
//  }
//
//  func clearInputs() {
//    self.amountString = ""
//    self.memoString = ""
//    self.dateSelected = false
//    self.categorySelected = false
//    self.accountSelected = false
//    self.transactionType = -1
//    self.approvalType = -1
//  }

  var body: some View {
    NavigationView {
      Form {
        TextField("Amount", text: $amountString).keyboardType(.decimalPad)

        TextField("Memo", text: $memoString)

        DatePicker(selection: $selectedDate,
                   in: ...Date(),
                   displayedComponents: .date) {
          Text("Transaction Date: ")
        }

        Picker(selection: $selectedCategory, label: Text("Select Category")) {
          ForEach(0..<self.viewModel.transactionCategories!.count) {
            Text(self.viewModel.transactionCategories![$0])
          }
        }

        Picker(selection: $selectedAccount, label: Text("Select Account")) {
          ForEach(0..<self.viewModel.transactionAccounts!.count) {
            Text(self.viewModel.transactionAccounts![$0])
          }
        }

        Picker(selection: $transactionType, label: Text("Transaction Type")) {
          Text("Inflow").tag(0)
          Text("Outflow").tag(1)
        }.pickerStyle(SegmentedPickerStyle())

        Picker(selection: $approvalType, label: Text("Approval Type")) {
          Text("Approved").tag(0)
          Text("Pending").tag(1)
        }.pickerStyle(SegmentedPickerStyle())

        if showAddButton {
          Button(action: {
            print("Add Transaction")
          }, label: {
            Text("Add Transaction")
          })
        }
      }.navigationBarTitle(Text("Add Transaction"))
    }.onTapGesture {
      UIApplication.shared.sendAction(
        #selector(UIResponder.resignFirstResponder),
        to: nil,
        from:
          nil,
        for: nil
      )
    }
//    VStack {
//      BannerView(baseColor: .materialLightBlue800) {
//        Text("Add Trasnsaction")
//          .bannerTitle(size: .medium)
//      }
//
//      BannerView(baseColor: .materialBlue800) {
//        VStack(spacing: 2) {
//          Text("Enter amount")
//            .font(.karlaBold(size: 12))
//            .foregroundColor(.white)
//
//          TextField("0.00", text: $amountString)
//            .multilineTextAlignment(.center)
//            .keyboardType(.decimalPad)
//            .bannerTitle(size: .large)
//        }.padding(.top, -30)
//      }
//      .cornerRadius(24)
//      .shadow(radius: 5)
//      .padding(.top, -30)
//
//      ScrollView {
//
//        AspireTextField(
//          text: $memoString,
//          placeHolder: "Add Memo",
//          imageName: "memo_icon",
//          keyboardType: .default
//        )
//
//        DatePicker(selection: $selectedDate,
//                   in: ...Date(),
//                   displayedComponents: .date) {
//          Text("Transaction Date: ")
//        }.padding()
//
//        Button("Select Category") {
//          self.showCategoriesPicker.toggle()
//        }.popover(isPresented: self.$showCategoriesPicker, attachmentAnchor: .point(.bottom)) {
//          Picker(selection: $selectedCategory, label: Text("Select Category")) {
//            ForEach(0..<self.viewModel.transactionCategories!.count) {
//              Text(self.viewModel.transactionCategories![$0])
//                .foregroundColor(.primaryTextColor)
//            }
//          }
//        }
//
//        AspirePickerButton(title: getDateString(), imageName: "calendar_icon") {
//          withAnimation {
//            self.dateSelected = true
//            self.showDatePicker.toggle()
//          }
//        }.sheet(isPresented: self.$showDatePicker, content: {
//          DatePicker(selection: $selectedDate, in: ...Date(), displayedComponents: .date) {
//            Text("")
//          }
//        })
//
//      }.background(Color.primaryBackgroundColor)
//      .cornerRadius(24)
//      .shadow(radius: 5)
//      .padding(.top, -40)
//      .edgesIgnoringSafeArea(.all)
//    }
//    ScrollView {
//      Group {
//        AspireTextField(
//          text: $amountString,
//          placeHolder: "Enter Amount",
//          imageName: "dollar_icon",
//          keyboardType: .decimalPad
//        )
//

//      }
//
//      AspirePickerButton(title: getDateString(), imageName: "calendar_icon") {
//        withAnimation {
//          self.dateSelected = true
//          self.showDatePicker.toggle()
//        }
//      }
//      if showDatePicker {
//        DatePicker(selection: $selectedDate, in: ...Date(), displayedComponents: .date) {
//          Text("")
//        }.foregroundColor(Color.white)
//      }
//      AspirePickerButton(title: getSelectedCategory(), imageName: "categories_icon") {
//        withAnimation {
//          self.categorySelected = true
//          self.showCategoriesPicker.toggle()
//        }
//      }.disabled(self.sheetsManager.transactionCategories == nil)
//      if showCategoriesPicker {
//        Picker(selection: $selectedCategory, label: Text("")) {
//          ForEach(0..<self.sheetsManager.transactionCategories!.count) {
//            Text(self.sheetsManager.transactionCategories![$0])
//              .foregroundColor(.white)
//          }
//        }
//      }
//
//      AspirePickerButton(title: getSelectedAccount(), imageName: "accounts_icon") {
//        withAnimation {
//          self.accountSelected = true
//          self.showAccountPicker.toggle()
//        }
//      }.disabled(self.sheetsManager.transactionAccounts == nil)
//      if showAccountPicker {
//        Picker(selection: $selectedAccount, label: Text("")) {
//          ForEach(0..<self.sheetsManager.transactionAccounts!.count) {
//            Text(self.sheetsManager.transactionAccounts![$0])
//              .foregroundColor(.white)
//          }
//        }
//      }
//
//      AspireRadioControl(
//        selectedOption: $transactionType,
//        firstOption: "Inflow",
//        secondOption: "Outflow"
//      )
//
//      AspireRadioControl(
//        selectedOption: $approvalType,
//        firstOption: "Approved",
//        secondOption: "Pending"
//      )
//
//      AspireButton(title: "Add", type: .green) {
//        if !self.amountString.isEmpty,
//          self.dateSelected,
//          self.categorySelected,
//          self.accountSelected {
//          self.sheetsManager.addTransaction(
//            amount: self.amountString,
//            memo: self.memoString,
//            date: self.selectedDate,
//            category: self.selectedCategory,
//            account: self.selectedAccount,
//            transactionType: self.transactionType,
//            approvalType: self.approvalType
//          ) { result in
//            self.clearInputs()
//            self.transactionAdded = result
//            self.showingAlert = true
//          }
//        }
//      }.padding().alert(isPresented: $showingAlert) { () -> Alert in
//        if self.transactionAdded {
//          return Alert(title: Text("Transaction added"))
//        } else {
//          return Alert(title: Text("An error occured. Please try again."))
//        }
//      }
//    }.background(Colors.aspireGray)
//      .edgesIgnoringSafeArea(.all)
//      .onTapGesture {
//        UIApplication.shared.sendAction(
//          #selector(UIResponder.resignFirstResponder),
//          to: nil,
//          from:
//          nil,
//          for: nil
//        )
//      }
  }
}

// struct AddTransactionView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddTransactionView()
//    }
// }

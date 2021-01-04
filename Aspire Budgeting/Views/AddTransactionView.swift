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

  @State private var selectedDate = Date()

  @State private var selectedCategory = -1
  @State private var selectedAccount = -1

  @State private var transactionType = -1
  @State private var approvalType = -1

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

  func clearInputs() {
    self.amountString = ""
    self.memoString = ""
    self.transactionType = -1
    self.approvalType = -1
  }

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
  }
}

// struct AddTransactionView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddTransactionView()
//    }
// }

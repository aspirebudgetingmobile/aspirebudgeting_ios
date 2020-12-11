//
// CategoryListView.swift
// Aspire Budgeting
//

import SwiftUI

struct CategoryListView: View {
  let categories: [Category]
  let tintColor: Color

  private func getAuxillaryText(spent: AspireNumber, budgeted: AspireNumber) -> String {
    "\(spent.stringValue) spent • \(budgeted.stringValue) budgeted"
  }

  var body: some View {
    ScrollView {
      ForEach(categories, id: \.self) { category in
        VStack(alignment: .leading) {
          HStack {
            Text(category.categoryName)
              .font(.karlaBold(size: 16))
              .foregroundColor(.primaryTextColor)
            Spacer()
            AspireNumberView(number: category.available)
          }
          HStack {
            Text(getAuxillaryText(spent: category.spent,
                                  budgeted: category.budgeted))
              .font(.karlaRegular(size: 14))
              .foregroundColor(.secondaryTextColor)
            Spacer()

            Text("available")
              .font(.karlaRegular(size: 14))
              .foregroundColor(.secondaryTextColor)
          }

          AspireProgressBar(barType: .minimal,
                            shadowColor: .gray,
                            tintColor: tintColor,
                            progressFactor: category.available /| category.monthly)
        }
        .padding([.bottom, .horizontal])
      }
    }
  }
}

struct CategoryListView_Previews: PreviewProvider {
  static var previews: some View {
    CategoryListView(categories: MockProvider.cardViewItems[0].categories,
                     tintColor: .materialBrown800)
  }
}

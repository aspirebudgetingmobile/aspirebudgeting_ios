//
//  AspireNavigationBar.swift
//  Aspire Budgeting
//

import SwiftUI

struct AspireNavigationBar: View {

  @Binding var title: String

  @State var showCategoryTransfer = false

  var body: some View {
    ZStack(alignment: .bottom) {
      Color.primaryBackgroundColor
      Text(title)
        .font(.nunitoBold(size: 20))
        .foregroundColor(.primaryTextColor)
        .alignmentGuide(.bottom, computeValue: { d in
          d[.bottom] + (d.height / 4)
        })

      HStack(alignment: .center) {
        Spacer()
        Button(action: {
          showCategoryTransfer = true
        }, label: {
          Image(systemName: "repeat")
        })
        .alignmentGuide(VerticalAlignment.center, computeValue: { d in
          d[.bottom] + (d.height / 1.5)
        })
      }.padding(.trailing)
    }
    .popover(isPresented: $showCategoryTransfer, content: {
      NavigationView {
//        CategoryTransferView()
      }
    })
  }
}

struct AspireNavigationBar_Previews: PreviewProvider {
  static var previews: some View {
    AspireNavigationBar(title: .constant("Dashboard"))
  }
}

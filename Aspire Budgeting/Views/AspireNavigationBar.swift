//
//  AspireNavigationBar.swift
//  Aspire Budgeting
//

import SwiftUI

struct AspireNavigationBar: View {

  @Binding var title: String

  var body: some View {
    ZStack(alignment: .bottom) {
      Color.primaryBackgroundColor
      Text(title)
        .font(.nunitoBold(size: 20))
        .foregroundColor(.primaryTextColor)
    }
  }
}

struct AspireNavigationBar_Previews: PreviewProvider {
  static var previews: some View {
    AspireNavigationBar(title: .constant("Dashboard"))
  }
}

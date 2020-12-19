//
// BannerView.swift
// Aspire Budgeting
//

import SwiftUI

struct BannerView<Content: View>: View {
  let content: Content
  let baseColor: Color

  private let bannerHeight: CGFloat = 100

  init(baseColor: Color,
       @ViewBuilder content: () -> Content) {
    self.baseColor = baseColor
    self.content = content()
  }

  var body: some View {
    ZStack {
      Rectangle()
        .fill(baseColor)
        .frame(height: bannerHeight)
      content
    }
  }
}

struct BannerView_Previews: PreviewProvider {
  static var previews: some View {
    BannerView(baseColor: .materialBlue800) {
      Text("Investments")
    }
  }
}

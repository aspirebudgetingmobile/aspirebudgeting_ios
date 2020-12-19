//
// BannerView.swift
// Aspire Budgeting
//

import SwiftUI

struct BannerView: View {
  let title: String
  let baseColor: Color

  private let bannerHeight: CGFloat = 100

  var body: some View {
    ZStack {
      Rectangle()
        .fill(baseColor)
        .frame(height: bannerHeight)
      Text(title)
        .font(.nunitoBold(size: 22))
        .foregroundColor(.white)
    }
  }
}

struct BannerView_Previews: PreviewProvider {
  static var previews: some View {
    BannerView(title: "Category Transfer", baseColor: .materialBlue800)
  }
}

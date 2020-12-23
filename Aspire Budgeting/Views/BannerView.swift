//
// BannerView.swift
// Aspire Budgeting
//

import SwiftUI
struct BannerViewTitle: ViewModifier {
  enum BannerTitleSize: CGFloat {
    case medium = 22
    case large = 38
  }

  let size: BannerTitleSize

  func body(content: Content) -> some View {
    content
      .font(.nunitoBold(size: size.rawValue))
      .foregroundColor(.white)
  }
}

extension View {
  func bannerTitle(size: BannerViewTitle.BannerTitleSize) -> some View {
    self.modifier(BannerViewTitle(size: size))
  }
}
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

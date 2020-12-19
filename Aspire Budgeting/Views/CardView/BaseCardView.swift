//
//  BaseCardView.swift
//  Aspire Budgeting
//

import SwiftUI

struct BaseCardView: View {

  let colorInfo: ColorInfo
  var minY: CGFloat = 0
  var curY: CGFloat = 0

  private let cornerRadius: CGFloat = 24
  private let height: CGFloat = 163

  private let shadowRadius: CGFloat = 14
  private let shadowYOffset: CGFloat = 4

  private var gradient: LinearGradient {
    Color.fondGradientFrom(startColor: colorInfo.gradientStartColor,
                           endColor: colorInfo.gradientEndColor)
  }

  private var offsetY: CGFloat {
    curY < minY ? minY - curY : 0
  }

  var body: some View {
    ZStack(alignment: .top) {
      containerBox
    }
    .offset(y: offsetY)
  }
}

extension BaseCardView {
  private var containerBox: some View {
    Rectangle()
      .fill(gradient)
      .cornerRadius(cornerRadius)
      .frame(height: height)
  }
}

// MARK: - Internal Types
extension BaseCardView {
  struct ColorInfo {
    let gradientStartColor: Color
    let gradientEndColor: Color
    let shadowColor: Color
  }

  struct CardViewItem {
    let title: String
    let availableTotal: AspireNumber
    let budgetedTotal: AspireNumber
    let spentTotal: AspireNumber
    let progressFactor: Double
    let categories: [Category]
  }
}

// MARK: - Previews
struct CardView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      Group {
        BaseCardView(colorInfo: .init(gradientStartColor: .materialBrown800,
                                  gradientEndColor: .materialBrown800,
                                  shadowColor: .materialBrown800)/**,
                 cardViewItem: MockProvider.cardViewItems[0]*/)

        BaseCardView(colorInfo: .init(gradientStartColor: .materialDeepPurple800,
                                  gradientEndColor: .materialDeepPurple800,
                                  shadowColor: .materialDeepPurple800)/**,
                 cardViewItem: MockProvider.cardViewItems[1]*/)
      }
    }
  }
}

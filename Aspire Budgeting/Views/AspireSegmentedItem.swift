//
//  AspireSegmentedItem.swift
//  Aspire Budgeting
//
//  Created by TeraMo Labs on 4/4/20.
//  Copyright © 2020 TeraMo Labs. All rights reserved.
//

import SwiftUI

struct AspireSegmentedItem: View {
  let title: String
  let itemIndex: Int
  @Binding var selectedSegment: Int

  private var opacity: Double {
    return selectedSegment == itemIndex ? 1 : 0.1
  }

  var body: some View {
    VStack {
      Spacer()
      Button(action: {
        self.selectedSegment = self.itemIndex
      }) {
        Text(title)
          .tracking(1)
          .font(.rubikRegular(size: 18))
          .foregroundColor(.white)
          .opacity(self.opacity)
      }.disabled(selectedSegment == self.itemIndex)
      Spacer()
      if selectedSegment == itemIndex {
        Rectangle()
          .frame(height: 3)
          .foregroundColor(Colors.segmentRed)
      }
    }
    .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 55)
  }
}

struct AspireSegmentedItem_Previews: PreviewProvider {
  static var previews: some View {
    AspireSegmentedItem(
      title: "Dashboard",
      itemIndex: 0,
      selectedSegment: .constant(0)
    )
  }
}

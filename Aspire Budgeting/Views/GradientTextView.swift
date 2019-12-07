//
//  GradientTextView.swift
//  Aspire Budgeting
//
//  Created by TeraMo Labs on 12/7/19.
//  Copyright © 2019 TeraMo Labs. All rights reserved.
//

import SwiftUI

struct GradientTextView: View {
  let string: String
  let tracking: CGFloat
  let font: Font
  let paddingEdges: Edge.Set
  let paddingLength: CGFloat?
  let gradient: LinearGradient

    var body: some View {
        Text(string)
          .tracking(tracking)
          .font(font)
          .padding(paddingEdges, paddingLength)
          .foregroundColor(.clear)
          .overlay(gradient
            .mask(Text(string)
              .tracking(1)
              .font(font)
              .scaledToFill()))
    }
}

//struct GradientTextView_Previews: PreviewProvider {
//    static var previews: some View {
//        GradientTextView()
//    }
//}

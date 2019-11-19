//
//  AspireNavigationBar.swift
//  Aspire Budgeting
//
//  Created by TeraMo Labs on 11/18/19.
//  Copyright © 2019 TeraMo Labs. All rights reserved.
//

import SwiftUI

struct AspireNavigationBar: View {
  var body: some View {
//    VStack {
      ZStack {
        Colors.aspireGray
        VStack {
          Spacer()
          HStack {
            Image(systemName: "equal.circle")
            Text("Aspire")
          }
        }.padding(.bottom, 15)
      }
//    }
  }
}

struct AspireNavigationBar_Previews: PreviewProvider {
  static var previews: some View {
    AspireNavigationBar()
  }
}

//
//  AspireNavigationBar.swift
//  Aspire Budgeting
//
//  Created by TeraMo Labs on 11/18/19.
//  Copyright © 2019 TeraMo Labs. All rights reserved.
//

import SwiftUI

struct AspireNavigationBar: View {
  @State var showSettings = false
  var body: some View {
//    VStack {
      ZStack {
        Colors.aspireGray
        VStack {
          Spacer()
          HStack {
            Image("logo").resizable().aspectRatio(contentMode: .fit).frame(maxHeight: 60)
            Text("Aspire").font(.custom("Nunito-Regular", size: 30)).foregroundColor(.white)
          }
        }.padding(.bottom, 5)
        VStack {
          Spacer()
          HStack {
            Spacer()
            Button(action: {
              print("Settings")
              self.showSettings = true
            }) {
              Image(systemName: "gear").padding().foregroundColor(.white)
            }.padding([.top, .bottom], 10)
              .sheet(isPresented: $showSettings) {
              Text("Modal")
            }
          }
        }
      }
//    }
  }
}

struct AspireNavigationBar_Previews: PreviewProvider {
  static var previews: some View {
    AspireNavigationBar()
  }
}

//
//  FaceIDView.swift
//  Aspire Budgeting
//
//  Created by TeraMo Labs on 11/9/19.
//  Copyright © 2019 TeraMo Labs. All rights reserved.
//

import SwiftUI

struct FaceIDView: View {
  @EnvironmentObject var localAuthorizationManager: LocalAuthorizationManager
  @EnvironmentObject var stateManager: StateManager

  var body: some View {
    ZStack {
      Rectangle().edgesIgnoringSafeArea(.all).foregroundColor(Colors.aspireGray)
      VStack {
        Image("logo")
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(maxHeight: 150)
        Text("Aspire")
          .font(.custom("Nunito-Regular", size: 30))
          .foregroundColor(.white)
          .padding(-20)
        Spacer()
        Text("Continue by using FaceID, TouchID or your Passcode")
          .font(.custom("Rubik-Light", size: 18))
          .padding()
          .multilineTextAlignment(.center)
          .foregroundColor(Color.white)
          .opacity(0.6)
      }
    }
  }
}

struct FaceIDView_Previews: PreviewProvider {
  static var previews: some View {
    FaceIDView()
  }
}

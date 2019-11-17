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
      VStack {
        Group {
          Image("logo").resizable().aspectRatio(contentMode: .fit).frame(maxHeight: 150)
          Text("Aspire").font(.custom("Nunito-Regular", size: 30)).foregroundColor(.white).padding(-20)
          Divider().background(Color.white).padding(.horizontal, 20)
        }
        Spacer()

        if stateManager.currentState == StateManager.State.localAuthFailed {
          Text("Continue by Using FaceID, TouchID or your Passcode").padding().multilineTextAlignment(.center)
        }
      }.onAppear {
        if self.stateManager.currentState == StateManager.State.needsLocalAuthentication {
          self.localAuthorizationManager.authenticateUserLocally()
        }
      }
  }
}

struct FaceIDView_Previews: PreviewProvider {
    static var previews: some View {
        FaceIDView()
    }
}

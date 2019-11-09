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
        Image("logo").resizable().aspectRatio(contentMode: .fit)
        Text("Aspire").font(.custom("Nunito-Regular", size: 50)).foregroundColor(.black)
        
        if stateManager.currentState == StateManager.State.localAuthFailed {
          Text("Authenticate face")
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

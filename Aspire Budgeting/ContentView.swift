//
//  ContentView.swift
//  Aspire Budgeting
//
//

import Combine
import GoogleSignIn
import SwiftUI

struct ContentView: View {
  @EnvironmentObject var userManager: UserManager<GIDGoogleUser>
  @EnvironmentObject var driveManager: GoogleDriveManager
  @EnvironmentObject var sheetsManager: GoogleSheetsManager
  @EnvironmentObject var localAuthorizationManager: LocalAuthorizationManager
  @EnvironmentObject var stateManager: StateManager

  var needsLocalAuth: Bool {
    return stateManager.currentState == StateManager.State.verifiedGoogleUser
      || stateManager.currentState == StateManager.State.localAuthFailed
      || stateManager.currentState == StateManager.State.needsLocalAuthentication
  }

  var isLoggedOut: Bool {
    return stateManager.currentState == StateManager.State.loggedOut
  }

  var hasDefaultSheet: Bool {
    stateManager.currentState == StateManager.State.hasDefaultSheet
  }

  var body: some View {
    VStack {
      if isLoggedOut {
        SignInView()
          .frame(maxHeight: .infinity)
          .animation(Animation
                      .spring()
                      .speed(1.0))
          .transition(.move(edge: .trailing))
      } else if needsLocalAuth {
        FaceIDView()
      } else if hasDefaultSheet {
        AspireMasterView()
      } else {
        FileSelectorView()
          .animation(Animation.spring().speed(1.0)).transition(.move(edge: .trailing))
      }
    }.background(Color.primaryBackgroundColor.edgesIgnoringSafeArea(.all))
  }
}

// struct ContentView_Previews: PreviewProvider {
//  static let objectFactory = ObjectFactory()
//    static var previews: some View {
//      ContentView(userManager: objectFactory.userManager,
//                  driveManager: objectFactory.driveManager,
//                  sheetsManager: objectFactory.sheetsManager,
//                  localAuthorizationManager: objectFactory.localAuthorizationManager,
//                  stateManager: objectFactory.stateManager)
//    }
// }

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
  
  @State private var cancellable: AnyCancellable!
  
  var body: some View {
    VStack {
      if stateManager.currentState == StateManager.State.loggedOut {
        SignInView().animation(Animation.spring().speed(1.0)).transition(.move(edge: .trailing))
      } else if stateManager.currentState == StateManager.State.verifiedGoogleUser ||
      stateManager.currentState == StateManager.State.localAuthFailed ||
      stateManager.currentState == StateManager.State.needsLocalAuthentication {
        FaceIDView()
      } else {
        
        FileSelectorView().animation(Animation.spring().speed(1.0)).transition(.move(edge: .trailing))
      }
    }.background(BackgroundColorView())
  }
}

//struct ContentView_Previews: PreviewProvider {
//  static let objectFactory = ObjectFactory()
//    static var previews: some View {
//      ContentView(userManager: objectFactory.userManager, driveManager: objectFactory.driveManager)
//    }
//}

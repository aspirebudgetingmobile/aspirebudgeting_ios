//
//  ContentView.swift
//  Aspire Budgeting
//
//

import Combine
import GoogleSignIn
import SwiftUI

struct ContentView: View {
  @EnvironmentObject var userManager: GoogleUserManager
  @EnvironmentObject var driveManager: GoogleDriveManager
  @EnvironmentObject var sheetsManager: GoogleSheetsManager
  @EnvironmentObject var appCoordinator: AppCoordinator

  var needsLocalAuth: Bool {
    appCoordinator.needsLocalAuth
  }

  var isLoggedOut: Bool {
    appCoordinator.isLoggedOut
  }

  var hasDefaultSheet: Bool {
    appCoordinator.hasDefaultSheet
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
        FileSelectorView(viewModel: appCoordinator.fileSelectorVM)
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

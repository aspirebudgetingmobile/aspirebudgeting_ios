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
  
  @State private var cancellable: AnyCancellable!
  
  var body: some View {
    VStack {
      if !userManager.userAuthenticated {
        SignInView().animation(Animation.spring().speed(1.0)).transition(.move(edge: .trailing))
      } else {
        
        FileSelectorView().animation(Animation.spring().speed(1.0)).transition(.move(edge: .trailing))
      }
//      else {
//        Button("Try again") {
//          self.localAuthorizationManager.authenticateUserLocally()
//        }
//      }
    }.background(BackgroundColorView()).onAppear {
      self.cancellable = self.userManager.$user.sink { (user) in
        if let user = user {
          if user.isFreshUser == false {
//            self.localAuthorizationManager.authenticateUserLocally()
          }
        }
      }
    }
  }
}

//struct ContentView_Previews: PreviewProvider {
//  static let objectFactory = ObjectFactory()
//    static var previews: some View {
//      ContentView(userManager: objectFactory.userManager, driveManager: objectFactory.driveManager)
//    }
//}

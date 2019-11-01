//
//  ContentView.swift
//  Aspire Budgeting
//
//

import SwiftUI

struct ContentView: View {
  @EnvironmentObject var userManager: UserManager
  @EnvironmentObject var driveManager: GoogleDriveManager
  @EnvironmentObject var sheetsManager: GoogleSheetsManager
  
  var body: some View {
    VStack {
      if userManager.user == nil {
        SignInView().animation(Animation.spring().speed(1.0)).transition(.move(edge: .trailing))
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

//
// ApplicationRootView.swift
// Aspire Budgeting
//

import Foundation
import SwiftUI

struct ApplicationRootView: View {
//  @ObservedObject var applicationStateObservable: ApplicationStateObservable
//
//  var body: some View {
//    getViewForApplicationState(applicationStateObservable.applicationState)
//  }
//
//  private func getViewForApplicationState(_ applicationState: ApplicationState) -> some View {
//    switch applicationState {
//    case .launching, .launched:
//      let launchView = LaunchView()
//      return AnyView(launchView)
//    case .requiresSignIn:
//      return AnyView(SignInView())
//    case .requiresAuthentication:
//      return AnyView(FaceIDView())
//    case .main:
//      return AnyView(AspireMasterView())
//    }
//  }

  @Binding var view: some View

  var body: some View {
    view
  }
}

struct BaseView: View {
  let text: String
  var body: some View {
    Text(text)
  }
}

struct LaunchView: View {
  var body: some View {
    ZStack {
      Colors.aspireGray
      Image("logo")
    }
    .edgesIgnoringSafeArea(.all)
  }
}

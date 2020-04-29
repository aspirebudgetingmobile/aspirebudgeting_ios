//
//  SignInView.swift
//  Aspire Budgeting
//
//  Created by TeraMo Labs on 10/20/19.
//  Copyright © 2019 TeraMo Labs. All rights reserved.
//

import GoogleSignIn
import SwiftUI

struct SignInView: View {
  @EnvironmentObject var userManager: UserManager<GIDGoogleUser>

  private let rootVC = UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.rootViewController

  var body: some View {
    VStack {
      Group {
        Image("logo")
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(minHeight: 20)
        Text("Aspire")
          .font(.custom("Nunito-Regular", size: 30))
          .foregroundColor(.white)
          .padding(-20)
        Divider().background(Color.white).padding(.horizontal, 20)
      }
      Group {
        Text("Link your Google Account")
          .font(.body)
          .foregroundColor(.white)
        Text("Aspire Budgeting requires you to either link your existing budget sheet or create a new budget sheet in your Google Drive")
          .font(.caption)
          .foregroundColor(.white)
          .padding(10)
          .multilineTextAlignment(.center)
      }

      YoutubePlayerView().padding(.horizontal).frame(minHeight: 80).shadow(radius: 5)

      AspireButton(title: "Connect your Google account", type: .green, imageName: "google") {
        self.userManager.signInWithGoogle(in: self.rootVC)
      }.frame(height: 50)
        .padding()
        .shadow(radius: 5)
      HStack {
        VStack {
          Divider().padding(.horizontal, 20)
        }
        Text("OR")
        VStack {
          Divider().padding(.horizontal, 20)
        }
      }

      AspireButton(title: "Copy Aspire sheet to your Google Drive", type: .red) {
        let url = URL(string: "https://aspirebudget.com")
        UIApplication.shared.open(url!)
      }.frame(height: 50)
        .padding()
        .shadow(radius: 5)

      Spacer()
    }.background(BackgroundSplitColorView().edgesIgnoringSafeArea(.all))
  }
}

struct SignInView_Previews: PreviewProvider {
  static var previews: some View {
    SignInView()
  }
}

//
//  SignInView.swift
//  Aspire Budgeting
//
//  Created by TeraMo Labs on 10/20/19.
//  Copyright © 2019 TeraMo Labs. All rights reserved.
//

import SwiftUI

struct SignInView: View {
  var body: some View {
    VStack {
      
      Group {
        Image("logo").resizable().aspectRatio(contentMode: .fit).frame(minHeight: 20)
        Text("Aspire").font(.custom("Nunito-Regular", size: 30)).foregroundColor(.white).padding(-20)
        Divider().background(Color.white).padding(.horizontal, 20)
      }
      
      Group {
        Text("Link your Google Account").font(.body).foregroundColor(.white)
        Text("Aspire Budgeting requires you to either link your existing budget sheet or create a new budget sheet in your Google Drive").font(.caption).foregroundColor(.white).padding(10).multilineTextAlignment(.center)
      }
      
      YoutubePlayerView().padding(.horizontal).frame(minHeight: 80)
      
      Group {
        Text("Step 1")
        GoogleSignInButton().frame(height: 50).padding(.horizontal)
      }
      
      Text("Step 2")
      GoogleSignInButton().frame(height: 50).padding(.horizontal)
      
      HStack {
        VStack {
          Divider().padding(.horizontal, 20)
        }
        
        Text("OR")
        
        VStack {
          Divider().padding(.horizontal, 20)
        }
      }
      GoogleSignInButton().frame(height: 50).padding(.horizontal)
      Button("Privacy Policy", action: {
        
      })
      Spacer()
    }.background(BackgroundSplitColorView().edgesIgnoringSafeArea(.all))
  }
}

struct SignInView_Previews: PreviewProvider {
  static var previews: some View {
    SignInView()
  }
}

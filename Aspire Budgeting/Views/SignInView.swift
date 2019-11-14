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
            Image("logo").resizable().aspectRatio(contentMode: .fit).frame(width: 150, height: 150)
            Text("Aspire").font(.custom("Nunito-Regular", size: 30)).foregroundColor(.white).padding(-20)
          }
          Divider().background(Color.white).padding(.horizontal, 20)
          Group {
            Text("Link your Google Account").font(.body).foregroundColor(.white)
            Text("Aspire Budgeting requires you to either link your existing budget sheet or create a new budget sheet on your Google Drive").font(.caption).foregroundColor(.white).padding(10).multilineTextAlignment(.center)
          }
          
          YoutubePlayerView().padding()
          Text("Step 1")
//          Spacer()
//          Text("Link your Google Account").font(.title).foregroundColor(.white)
//          Text("Why? Aspire Budgeting requires access to your Google Sheets in order to be able to display your budgeting sheet.").foregroundColor(.white).font(.footnote).padding(.horizontal)
          GoogleSignInButton().frame(height: 50).padding()
          Text("Step 2")
          GoogleSignInButton().frame(height: 50).padding()
//          HStack {
//            VStack {
//              Divider().padding(20)
//            }
//
//            Text("OR")
//
//            VStack {
//              Divider().padding(20)
//            }
//          }
//          Group {
//            GoogleSignInButton().frame(height: 50).padding()
//            Text("Aspire Budgeting requires you to either link your existing budget sheet or create a new budget sheet on your Google Drive").font(.caption).padding(10).multilineTextAlignment(.center)
//          }
          
        }.background(BackgroundSplitColorView().edgesIgnoringSafeArea(.all))
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}

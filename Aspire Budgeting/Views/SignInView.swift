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
          Image("logo").resizable().aspectRatio(contentMode: .fit)
          Text("Aspire").font(.custom("Nunito-Regular", size: 50)).foregroundColor(.white)
          YoutubePlayerView().padding()
          Spacer()
          Text("Link your Google Account").font(.title).foregroundColor(.white)
          Text("Why? Aspire Budgeting requires access to your Google Sheets in order to be able to display your budgeting sheet.").foregroundColor(.white).font(.footnote).padding(.horizontal)
          GoogleSignInButton().frame(height: 50).padding()
          
          Spacer()
        }.background(BackgroundColorView().edgesIgnoringSafeArea(.all))
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}

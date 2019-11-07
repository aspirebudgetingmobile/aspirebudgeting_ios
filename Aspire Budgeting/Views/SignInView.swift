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
          Image("logo")
          Text("Aspire").font(.custom("Nunito-Regular", size: 50)).foregroundColor(.white)
          Spacer()
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

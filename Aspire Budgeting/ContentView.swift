//
//  ContentView.swift
//  Aspire Budgeting
//
//

import SwiftUI

struct ContentView: View {
    var body: some View {
      VStack {
        Image("logo")
        Spacer()
        GoogleSignInButton().frame(height: 50).padding()
        Spacer()
      }.background(BackgroundColorView().edgesIgnoringSafeArea(.all))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

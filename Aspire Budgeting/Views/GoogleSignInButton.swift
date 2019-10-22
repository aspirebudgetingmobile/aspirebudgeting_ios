//
//  GoogleSignInButton.swift
//  Aspire Budgeting
//
//  Created by TeraMo Labs on 10/20/19.
//  Copyright © 2019 TeraMo Labs. All rights reserved.
//

import SwiftUI
import GoogleSignIn

struct GoogleSignInButton: UIViewRepresentable {
  
  private var presentingViewController: UIViewController? {
    UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.rootViewController
  }
  
  
  func updateUIView(_ signInButton: GIDSignInButton, context: UIViewRepresentableContext<GoogleSignInButton>) {
    guard let presentingVC = presentingViewController else {
      signInButton.isEnabled = false
      return
    }
    
    GIDSignIn.sharedInstance()?.presentingViewController = presentingVC
  }
  
  func makeUIView(context: UIViewRepresentableContext<GoogleSignInButton>) -> GIDSignInButton {
    GIDSignInButton()
  }
}

struct GoogleSignInButton_Previews: PreviewProvider {
    static var previews: some View {
        GoogleSignInButton()
    }
}

//
//  GoogleSignInButton.swift
//  Aspire Budgeting
//
//  Created by TeraMo Labs on 10/20/19.
//  Copyright © 2019 TeraMo Labs. All rights reserved.
//

import GoogleSignIn
import SwiftUI

struct GoogleSignInButton: UIViewRepresentable {
  private var presentingViewController: UIViewController? {
    UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController
  }

  let colorScheme: ColorScheme

  func updateUIView(
    _ signInButton: GIDSignInButton,
    context: UIViewRepresentableContext<GoogleSignInButton>
  ) {
    guard let presentingVC = presentingViewController else {
      signInButton.isEnabled = false
      return
    }

    GIDSignIn.sharedInstance()?.presentingViewController = presentingVC
    signInButton.colorScheme = colorScheme == .light ? .light : .dark
  }

  func makeUIView(context: UIViewRepresentableContext<GoogleSignInButton>) -> GIDSignInButton {
    let button =
    GIDSignInButton()
    button.style = .wide

    return button
  }
}

struct GoogleSignInButton_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      GoogleSignInButton(colorScheme: .light)
      GoogleSignInButton(colorScheme: .dark)
    }
  }
}

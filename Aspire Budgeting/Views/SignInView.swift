//
//  SignInView.swift
//  Aspire Budgeting
//

import GoogleSignIn
import SwiftUI

struct SignInView: View {
  @EnvironmentObject var userManager: UserManager<GIDGoogleUser>
  @Environment (\.colorScheme) var colorScheme: ColorScheme

  private let rootVC = UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController

  var body: some View {
    VStack {
        Text("Aspire Budgeting")
          .font(.nunitoSemiBold(size: 20))
          .foregroundColor(.primaryTextColor)

      Image.circularLogo
        .padding(.top)

      Text("Welcome to Aspire Budgeting")
        .font(.nunitoRegular(size: 16))
        .foregroundColor(.primaryTextColor)
        .padding()

      Text("Take control of your money everywhere you go")
        .lineLimit(2)
        .font(.nunitoRegular(size: 14))
        .multilineTextAlignment(.center)
        .foregroundColor(.secondary)
        .frame(width: 173)

      Image.diamondSeparator
        .padding()

//      if colorScheme == .light || colorScheme == .dark{
        GoogleSignInButton(colorScheme: colorScheme)
          .frame(height: 50)
          .padding()
//      }
      
//      Text(colorScheme == .dark ? "In dark mode" : "In light mode")
          
    }
    .background(Color.primaryBackgroundColor)
  }
}

struct SignInView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      SignInView()
      SignInView().environment(\.colorScheme, .dark)
    }
  }
}

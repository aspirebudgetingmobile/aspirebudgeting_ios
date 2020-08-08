//
//  SignInView.swift
//  Aspire Budgeting
//

import SwiftUI

struct SignInView: View {
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

      GoogleSignInButton(colorScheme: colorScheme)
        .frame(height: 50)
        .padding()

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

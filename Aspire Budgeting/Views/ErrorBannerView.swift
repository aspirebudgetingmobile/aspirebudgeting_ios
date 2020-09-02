//
//  ErrorBannerView.swift
//  Aspire Budgeting
//

import SwiftUI

struct ErrorBannerView: View {
  var error: Error

  var body: some View {
    Text(error.localizedDescription).font(.custom("Rubik-Light", size: 18)).foregroundColor(.white).opacity(0.6)
  }
}

// struct ErrorBannerView_Previews: PreviewProvider {
//    static var previews: some View {
//        ErrorBannerView()
//    }
// }

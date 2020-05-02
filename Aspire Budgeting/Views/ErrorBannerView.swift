//
//  ErrorBannerView.swift
//  Aspire Budgeting
//
//  Created by TeraMo Labs on 11/2/19.
//  Copyright © 2019 TeraMo Labs. All rights reserved.
//

import SwiftUI

struct ErrorBannerView: View {
  var error: GoogleDriveManagerError

  var body: some View {
    Text(error.description)
      .font(.custom("Rubik-Light", size: 18))
      .foregroundColor(.white)
      .opacity(0.6)
  }
}

// struct ErrorBannerView_Previews: PreviewProvider {
//    static var previews: some View {
//        ErrorBannerView()
//    }
// }

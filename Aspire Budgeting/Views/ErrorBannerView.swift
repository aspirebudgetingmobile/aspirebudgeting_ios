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
      Text(error.rawValue).padding().background(Color.red)
  }
}

//struct ErrorBannerView_Previews: PreviewProvider {
//    static var previews: some View {
//        ErrorBannerView()
//    }
//}

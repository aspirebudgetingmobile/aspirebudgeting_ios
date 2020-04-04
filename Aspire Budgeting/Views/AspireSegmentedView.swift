//
//  AspireSegmentedView.swift
//  Aspire Budgeting
//
//  Created by TeraMo Labs on 12/7/19.
//  Copyright © 2019 TeraMo Labs. All rights reserved.
//

import SwiftUI

struct AspireSegmentedView: View {
  @Binding var selectedSegment: Int
  
  var body: some View {
    ZStack {
      Rectangle().frame(height: 55).background(Color.red).opacity(0.06)
      ScrollView(.horizontal, showsIndicators: false, content: {
        VStack {
          HStack(spacing: 0) {
            
            AspireSegmentedItem(title: "Dashboard",
                                itemIndex: 0, selectedSegment: $selectedSegment)
            
            AspireSegmentedItem(title: "Add Transaction",
                                itemIndex: 1, selectedSegment: $selectedSegment)
            
            AspireSegmentedItem(title: "Account Balances",
                                itemIndex: 2, selectedSegment: $selectedSegment)
            
          }
          .frame(minWidth: 0, maxWidth: .infinity)
          
        }
      })
    }
    
  }
}

//struct AspireSegmentedView_Previews: PreviewProvider {
//  static var previews: some View {
//    AspireSegmentedView()
//  }
//}

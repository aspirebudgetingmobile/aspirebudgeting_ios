//
//  AspireSegmentedView.swift
//  Aspire Budgeting
//
//  Created by TeraMo Labs on 12/7/19.
//  Copyright © 2019 TeraMo Labs. All rights reserved.
//

import SwiftUI

struct AspireSegmentedView: View {
  @State private var selectedSegment = 0
  
  var body: some View {
    ZStack {
      Rectangle().frame(height: 50).background(Color.red).opacity(0.06)
      VStack {
        HStack(spacing: 0) {
          
          VStack {
            Spacer()
            Button(action: {
              self.selectedSegment = 0
            }) {
              Text("Dashboard")
            }
            Spacer()
            if selectedSegment == 0 {
              Rectangle().frame(height: 3)
            }
            
          }
          .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 50).foregroundColor(.white)
          
          VStack {
            Spacer()
            Button(action: {
              self.selectedSegment = 1
            }) {
              Text("Add Transaction")
            }
            Spacer()
            if selectedSegment == 1 {
              Rectangle().frame(height: 3)
            }
          }
          .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 50).foregroundColor(.white)
          
        }
        .frame(minWidth: 0, maxWidth: .infinity)
        
      }
      
    }
    
  }
}

struct AspireSegmentedView_Previews: PreviewProvider {
  static var previews: some View {
    AspireSegmentedView()
  }
}

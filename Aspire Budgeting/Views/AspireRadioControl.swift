//
//  AspireRadioControl.swift
//  Aspire Budgeting
//
//  Created by TeraMo Labs on 4/24/20.
//  Copyright © 2020 TeraMo Labs. All rights reserved.
//

import SwiftUI

struct AspireRadioControl: View {
  @Binding var selectedOption: Int
  
  let firstOption: String
  let secondOption: String
  
  var body: some View {
    HStack {
      Text(firstOption)
        .padding(10)
        .frame(maxWidth: .infinity)
        .foregroundColor(Color.white)
        .font(.nunitoSemiBold(size: 25))
        .background(selectedOption == 0 ? Color(red: 0.196, green: 0.682, blue: 0.482 ) : Color.green.opacity(0))
        .overlay(RoundedRectangle(cornerRadius: 12.5).stroke(Color(red: 0.196, green: 0.682, blue: 0.482 ), lineWidth: 8))
        .cornerRadius(12.5).onTapGesture {
          self.selectedOption = 0
      }
      Spacer()
      Text(secondOption)
        .padding(10)
        .frame(maxWidth: .infinity)
        .foregroundColor(Color.white)
        .font(.nunitoSemiBold(size: 25))
        .background(selectedOption == 1 ? Color(red: 0.698, green: 0.145, blue: 0.341) : Color.red.opacity(0))
        .overlay(RoundedRectangle(cornerRadius: 12.5).stroke(Color(red: 0.698, green: 0.145, blue: 0.341), lineWidth: 8))
        .cornerRadius(12.5).onTapGesture {
          self.selectedOption = 1
      }
    }.padding()
  }
}

//struct AspireRadioControl_Previews: PreviewProvider {
//    static var previews: some View {
//        AspireRadioControl()
//    }
//}

//
//  Gradients.swift
//  Aspire Budgeting
//
//  Created by TeraMo Labs on 11/18/19.
//  Copyright © 2019 TeraMo Labs. All rights reserved.
//

import SwiftUI

struct Colors {
  static let greenGradient = LinearGradient(gradient: Gradient(colors: [Color(red: 95/255, green: 224/255, blue: 170/255), Color(red: 32/255, green: 172/255, blue: 122/255)]), startPoint: .top, endPoint: .bottom)
  
  static let redGradient = LinearGradient(gradient: Gradient(colors: [Color(red: 249/255, green: 121/255, blue: 124/255), Color(red: 213/255, green: 103/255, blue: 106/255)]), startPoint: .top, endPoint: .bottom)
  
  static let yellowGradient = LinearGradient(gradient: Gradient(colors: [Color(red: 239/255, green: 184/255, blue: 79/255), Color(red: 191/255, green: 140/255, blue: 42/255)]), startPoint: .top, endPoint: .bottom)
  
  static let aspireGray = Color(red: 53/255, green: 55/255, blue: 72/255)
}

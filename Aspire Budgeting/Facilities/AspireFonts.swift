//
//  AspireFonts.swift
//  Aspire Budgeting
//
//  Created by TeraMo Labs on 12/7/19.
//  Copyright © 2019 TeraMo Labs. All rights reserved.
//

import SwiftUI

extension Font {
  static func rubikRegular(size: CGFloat) -> Font {
    return Font.custom("Rubik-Regular", size: size)
  }

  static func rubikLight(size: CGFloat) -> Font {
    return Font.custom("Rubik-Light", size: size)
  }

  static func rubikMedium(size: CGFloat) -> Font {
    return Font.custom("Rubik-Medium", size: size)
  }

  static func nunitoSemiBold(size: CGFloat) -> Font {
    return Font.custom("Nunito-SemiBold", size: size)
  }
  
  static func nunitoRegular(size: CGFloat) -> Font {
    return Font.custom("Nunito-Regular", size: size)
  }
}

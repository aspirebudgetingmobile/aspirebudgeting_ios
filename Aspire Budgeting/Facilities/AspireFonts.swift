//
//  AspireFonts.swift
//  Aspire Budgeting
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

  static func nunitoBold(size: CGFloat) -> Font {
    return Font.custom("Nunito-Bold", size: size)
  }

  static func karlaRegular(size: Double) -> Font {
    return Font.custom("Karla-Regular", size: CGFloat(size))
  }
}

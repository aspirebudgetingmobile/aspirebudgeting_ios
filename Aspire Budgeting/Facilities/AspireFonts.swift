//
//  AspireFonts.swift
//  Aspire Budgeting
//

import SwiftUI

extension Font {
  static func rubikRegular(size: CGFloat) -> Font {
    Font.custom("Rubik-Regular", size: size)
  }

  static func rubikLight(size: CGFloat) -> Font {
    Font.custom("Rubik-Light", size: size)
  }

  static func rubikMedium(size: CGFloat) -> Font {
    Font.custom("Rubik-Medium", size: size)
  }

  static func nunitoSemiBold(size: CGFloat) -> Font {
    Font.custom("Nunito-SemiBold", size: size)
  }

  static func nunitoRegular(size: CGFloat) -> Font {
    Font.custom("Nunito-Regular", size: size)
  }

  static func nunitoBold(size: CGFloat) -> Font {
    Font.custom("Nunito-Bold", size: size)
  }

  static func karlaRegular(size: Double) -> Font {
    Font.custom("Karla-Regular", size: CGFloat(size))
  }

  static func karlaBold(size: Double) -> Font {
    Font.custom("Karla-Bold", size: CGFloat(size))
  }
}

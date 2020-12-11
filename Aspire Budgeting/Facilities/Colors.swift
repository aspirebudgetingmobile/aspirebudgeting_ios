//
//  Gradients.swift
//  Aspire Budgeting
//
//  Created by TeraMo Labs on 11/18/19.
//  Copyright © 2019 TeraMo Labs. All rights reserved.
//

import SwiftUI

enum Colors {
  static let greenGradient = LinearGradient(
    gradient: Gradient(
      colors: [
        Color(red: 95 / 255, green: 224 / 255, blue: 170 / 255),
        Color(red: 32 / 255, green: 172 / 255, blue: 122 / 255),
      ]
    ),
    startPoint: .top,
    endPoint: .bottom
  )

  static let redGradient = LinearGradient(
    gradient: Gradient(
      colors: [
        Color(red: 249 / 255, green: 121 / 255, blue: 124 / 255),
        Color(red: 213 / 255, green: 103 / 255, blue: 106 / 255),
      ]
    ),
    startPoint: .top,
    endPoint: .bottom
  )

  static let yellowGradient = LinearGradient(
    gradient: Gradient(
      colors: [
        Color(red: 239 / 255, green: 184 / 255, blue: 79 / 255),
        Color(red: 191 / 255, green: 140 / 255, blue: 42 / 255),
      ]
    ),
    startPoint: .top,
    endPoint: .bottom
  )

  static let aspireGray = Color(red: 53 / 255, green: 55 / 255, blue: 72 / 255)

  static let segmentRed = Color(red: 249 / 255, green: 121 / 255, blue: 124 / 255)
}

extension Color {
  static let primaryBackgroundColor = Color("primaryBackgroundColor")
  static let primaryTextColor = Color("primaryTextColor")
  static let secondaryTextColor = Color("secondaryTextColor")

  static let tabBarColor = Color("tabBarColor")

  static let tabBarItemDefaultTintColor = Color("tabBarItemDefaultTintColor")
  static let tabBarItemSelectedTintColor = Color("tabBarItemSelectedTintColor")

  static let materialRed800 = Color(#colorLiteral(red: 0.7758955956, green: 0.1865674257, blue: 0.1419894099, alpha: 1))
  static let materialPink800 = Color(#colorLiteral(red: 0.7418284416, green: 0.1682539582, blue: 0.4153811634, alpha: 1))
  static let materialPurple800 = Color(#colorLiteral(red: 0.4969367385, green: 0.2022175491, blue: 0.668427527, alpha: 1))
  static let materialDeepPurple800 = Color(#colorLiteral(red: 0.3443561196, green: 0.2432458401, blue: 0.6896080971, alpha: 1))
  static let materialIndigo800 = Color(#colorLiteral(red: 0.2073813081, green: 0.2909911275, blue: 0.6437862515, alpha: 1))
  static let materialBlue800 = Color(#colorLiteral(red: 0.08021575958, green: 0.4831395745, blue: 0.7987222075, alpha: 1))
  static let materialLightBlue800 = Color(#colorLiteral(red: 0, green: 0.5463507771, blue: 0.7886484265, alpha: 1))
  static let materialTeal800 = Color(#colorLiteral(red: 0, green: 0.4813188314, blue: 0.4364055395, alpha: 1))
  static let materialGreen800 = Color(#colorLiteral(red: 0.2200532258, green: 0.5519797206, blue: 0.255117625, alpha: 1))
  static let materialBrown800 = Color(#colorLiteral(red: 0.3812616765, green: 0.2670665383, blue: 0.2366400957, alpha: 1))
  static let materialGrey800 = Color(#colorLiteral(red: 0.3278279901, green: 0.3278364539, blue: 0.3278318942, alpha: 1))
  static let materialBlueGrey800 = Color(#colorLiteral(red: 0.2769027352, green: 0.3493474722, blue: 0.3832971156, alpha: 1))

  static func fondGradientFrom(startColor: Color,
                               endColor: Color) -> LinearGradient {
    let startColor = Gradient.Stop(color: startColor, location: 0)
    let endColor = Gradient.Stop(color: endColor, location: 1)

    let gradient = Gradient(stops: [startColor, endColor])

    return LinearGradient(gradient: gradient,
                          startPoint: UnitPoint(x: 0.5, y: -0.48),
                          endPoint: UnitPoint(x: -0.46, y: 0.52))
  }
}

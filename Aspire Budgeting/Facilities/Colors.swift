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

  static let blueGreenFondStartColor = Color(#colorLiteral(red: 0.5898134708404541, green: 0.9377264380455017, blue: 0.6503201127052307, alpha: 1))
  static let blueGreenFondEndColor = Color(#colorLiteral(red: 0.14806434512138367, green: 0.6510331034660339, blue: 0.7083333134651184, alpha: 1))
  static let blueGreenFondShadowColor = Color(#colorLiteral(red: 0.7650219202041626, green: 0.9187896251678467, blue: 0.8518016934394836, alpha: 1))

  static let blueFondStartColor = Color(#colorLiteral(red: 0.5148965120315552, green: 0.8234522938728333, blue: 0.9658910632133484, alpha: 1))
  static let blueFondEndColor = Color(#colorLiteral(red: 0.2846880257129669, green: 0.6192561388015747, blue: 0.924932062625885, alpha: 1))
  static let blueFondShadowColor = Color(#colorLiteral(red: 0.5176470875740051, green: 0.8235294222831726, blue: 0.9686274528503418, alpha: 1))

  static let lilacFondStartColor = Color(#colorLiteral(red: 0.9155210256576538, green: 0.6907393336296082, blue: 1, alpha: 1))
  static let lilacFondEndColor = Color(#colorLiteral(red: 0.5428763628005981, green: 0.38675519824028015, blue: 0.89622962474823, alpha: 1))
  static let lilacFondShadowColor = Color(#colorLiteral(red: 0.9019607901573181, green: 0.6784313917160034, blue: 0.9960784316062927, alpha: 1))

  static let mauveBlueFondStartColor = Color(#colorLiteral(red: 0.6312118768692017, green: 0.6372764110565186, blue: 1, alpha: 1))
  static let mauveBlueFondEndColor = Color(#colorLiteral(red: 0.4286275804042816, green: 0.3898088037967682, blue: 0.9375849366188049, alpha: 1))
  static let mauveBlueFondShadowColor = Color(#colorLiteral(red: 0.6235294342041016, green: 0.6274510025978088, blue: 1, alpha: 1))

  static let creamFondStartColor = Color(#colorLiteral(red: 0.9765058755874634, green: 0.8012461066246033, blue: 0.6603509187698364, alpha: 1))
  static let creamFondEndColor = Color(#colorLiteral(red: 0.8117647171020508, green: 0.6117647290229797, blue: 0.45098039507865906, alpha: 1))
  static let creamFondShadowColor = Color(#colorLiteral(red: 0.9607843160629272, green: 0.7843137383460999, blue: 0.6392157077789307, alpha: 1))

  static let redOrangeFondStartColor = Color(#colorLiteral(red: 1, green: 0.7020202279090881, blue: 0.5111268758773804, alpha: 1))
  static let redOrangeFondEndColor = Color(#colorLiteral(red: 0.9395195841789246, green: 0.4591575562953949, blue: 0.5647353529930115, alpha: 1))
  static let redOrangeFondShadowColor = Color(#colorLiteral(red: 0.9921568632125854, green: 0.6705882549285889, blue: 0.5176470875740051, alpha: 1))

  static let blueGradientFondStartColor = Color(#colorLiteral(red: 0.5646341443061829, green: 0.8002088069915771, blue: 1, alpha: 1))
  static let blueGradientFondEndColor = Color(#colorLiteral(red: 0.31172263622283936, green: 0.3512575924396515, blue: 0.9259227514266968, alpha: 1))
  static let blueGradientFondShadowColor = Color(#colorLiteral(red: 0.6024761199951172, green: 0.7943044900894165, blue: 0.992527186870575, alpha: 1))

  static let yellowFondStartColor = Color(#colorLiteral(red: 1, green: 0.8263959884643555, blue: 0.5280487537384033, alpha: 1))
  static let yellowFondEndColor = Color(#colorLiteral(red: 1, green: 0.6347344517707825, blue: 0.4213414490222931, alpha: 1))
  static let yellowFondShadowColor = Color(#colorLiteral(red: 1, green: 0.8274509906768799, blue: 0.501960813999176, alpha: 1))

  static let redPinkFondStartColor = Color(#colorLiteral(red: 1, green: 0.6956936120986938, blue: 0.6956936120986938, alpha: 1))
  static let redPinkFondEndColor = Color(#colorLiteral(red: 0.9228656888008118, green: 0.41528958082199097, blue: 0.6241822242736816, alpha: 1))
  static let redPinkFondShadowColor  = Color(#colorLiteral(red: 0.9803921580314636, green: 0.6549019813537598, blue: 0.7019608020782471, alpha: 1))

  static let greenFondStartColor = Color(#colorLiteral(red: 0.4947846233844757, green: 0.9449161887168884, blue: 0.5710781216621399, alpha: 1))
  static let greenFondEndColor = Color(#colorLiteral(red: 0.17628486454486847, green: 0.7840933203697205, blue: 0.5903543829917908, alpha: 1))
  static let greenFondShadowColor = Color(#colorLiteral(red: 0.4627451002597809, green: 0.929411768913269, blue: 0.572549045085907, alpha: 1))

  static let purpleFondStartColor = Color(#colorLiteral(red: 1, green: 0.7346036434173584, blue: 0.8102468252182007, alpha: 1))
  static let purpleFondEndColor = Color(#colorLiteral(red: 0.6505281925201416, green: 0.3958817720413208, blue: 0.8214730620384216, alpha: 1))
  static let purpleFondShadowColor = Color(#colorLiteral(red: 0.9686274528503418, green: 0.7058823704719543, blue: 0.8117647171020508, alpha: 1))
}

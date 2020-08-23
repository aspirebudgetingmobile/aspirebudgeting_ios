//
// Images.swift
// Aspire Budgeting
//

import SwiftUI

extension Image {
  static let circularLogo = Image("circularLogo")
  static let diamondSeparator = Image("diamondSeparator")
  static let magnifyingGlass = Image(systemName: "magnifyingglass")
  static let multiplyCircleFill = Image(systemName: "multiply.circle.fill")
  static let sheetsIcon = Image("sheetsIcon")

  static let dollarSignCircle = Image(systemName: "dollarsign.circle")
  static let yenSignCircle = Image(systemName: "yensign.circle")
  static let sterlingSignCircle = Image(systemName: "sterlingsign.circle")
  static let rubleSignCircle = Image(systemName: "rublesign.circle")
  static let euroSignCircle = Image(systemName: "eurosign.circle")
  static let indianRupeeSignCircle = Image(systemName: "indianrupeesign.circle")

  static let currencySymbols: [Image] = [.dollarSignCircle,
                                         .yenSignCircle,
                                         sterlingSignCircle,
                                         rubleSignCircle,
                                         euroSignCircle,
                                indianRupeeSignCircle, ]
}

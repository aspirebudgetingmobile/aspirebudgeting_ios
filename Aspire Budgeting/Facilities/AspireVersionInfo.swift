//
//  AspireVersionInfo.swift
//  Aspire Budgeting
//

import Foundation

enum AspireVersionInfo {
  private static let infoDictionary = Bundle.main.infoDictionary

  static var build: String {
    guard let build = (infoDictionary?["CFBundleVersion"] as? String) else {
      fatalError("Could not read Info.plist")
    }
    return build
  }

  static var version: String {
    guard let version = (infoDictionary?["CFBundleShortVersionString"] as? String) else {
      fatalError("Could not read Info.plist")
    }
    return version
  }
}

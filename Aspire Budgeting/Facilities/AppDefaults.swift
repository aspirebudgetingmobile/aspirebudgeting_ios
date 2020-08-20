//
// AppDefaults.swift
// Aspire Budgeting
//

import Foundation
import os.log

protocol AppDefaults {
  func getDefaultFile() -> File?
}

protocol AppUserDefaults {
  func data(forKey defaultName: String) -> Data?
  func set(_ value: Any?, forKey defaultName: String)
  func removeObject(forKey defaultName: String)
}

extension UserDefaults: AppUserDefaults {}

struct AppDefaultsManager: AppDefaults {
  private let userDefaults: AppUserDefaults
  private let defaultFileKey: String

  init(userDefaults: AppUserDefaults = UserDefaults(),
       defaultFileKey: String = "Aspire_Sheet") {
    self.userDefaults = userDefaults
    self.defaultFileKey = defaultFileKey
  }

  func getDefaultFile() -> File? {
    guard let data = userDefaults.data(forKey: defaultFileKey),
      let file = try? JSONDecoder().decode(File.self, from: data) else {
      os_log(
        "No default file found",
        log: .appDefaults,
        type: .default
      )
      return nil
    }

    os_log(
      "Default file found.",
      log: .appDefaults,
      type: .default
    )
    return file
  }
}

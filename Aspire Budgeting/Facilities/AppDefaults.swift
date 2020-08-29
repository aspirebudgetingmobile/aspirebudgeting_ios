//
// AppDefaults.swift
// Aspire Budgeting
//

import Foundation
import os.log

protocol AppDefaults {
  func getDefaultFile() -> File?
  func addDefault(file: File)
  func addDataMap(map: [String: String])
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
  private let dataMapKey: String

  init(userDefaults: AppUserDefaults = UserDefaults(),
       defaultFileKey: String = "Aspire_Sheet",
       dataMapKey: String = "Aspire_DataMap") {
    self.userDefaults = userDefaults
    self.defaultFileKey = defaultFileKey
    self.dataMapKey = dataMapKey
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

  func addDefault(file: File) {
    do {
      let data = try JSONEncoder().encode(file)
      userDefaults.set(data, forKey: defaultFileKey)
    } catch {
      fatalError("This should've never happened!!")
    }
  }

  func addDataMap(map: [String: String]) {
    userDefaults.set(map, forKey: dataMapKey)
  }
}

//
// AppDefaults.swift
// Aspire Budgeting
//

import Foundation

protocol AppDefaults {
  func getDefaultFile() -> File?
  func addDefault(file: File)
  func addDataLocationMap(map: [String: String])
  func getDataLocationMap() -> [String: String]
}

protocol AppUserDefaults {
  func data(forKey defaultName: String) -> Data?
  func set(_ value: Any?, forKey defaultName: String)
  func removeObject(forKey defaultName: String)
  func dictionary(forKey defaultName: String) -> [String: Any]?
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
      Logger.info(
        "No default file found"
      )
      return nil
    }

    Logger.info(
      "Default file found."
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

  func addDataLocationMap(map: [String: String]) {
    userDefaults.set(map, forKey: dataMapKey)
  }

  func getDataLocationMap() -> [String: String] {
    guard let map = userDefaults
            .dictionary(forKey: self.dataMapKey) as? [String: String] else {
      return [String: String]()
    }
    return map
  }
}

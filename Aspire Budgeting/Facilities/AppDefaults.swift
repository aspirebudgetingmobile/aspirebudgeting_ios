//
// AppDefaults.swift
// Aspire Budgeting
//

import Foundation

protocol AppDefaults {
  func addDefault(sheet: AspireSheet)
  func getDefaultSheet() -> AspireSheet?
  func clearDefaultFile()
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
  private let defaultSheetKey: String

  init(
    userDefaults: AppUserDefaults = UserDefaults(),
    defaultSheetKey: String = "Aspire_Sheet"
  ) {
    self.userDefaults = userDefaults
    self.defaultSheetKey = defaultSheetKey
  }

  func addDefault(sheet: AspireSheet) {
    do {
      let data = try JSONEncoder().encode(sheet)
      userDefaults.set(data, forKey: defaultSheetKey)
    } catch {
      fatalError("This should've never happened!!")
    }
  }

  func getDefaultSheet() -> AspireSheet? {
    guard let data = userDefaults.data(forKey: defaultSheetKey),
      let sheet = try? JSONDecoder().decode(AspireSheet.self, from: data) else {
      Logger.info(
        "No default sheet found"
      )
      return nil
    }

    Logger.info(
      "Default sheet found: \(sheet.file.name)"
    )
    return sheet
  }
//
//  func getDefaultFile() -> File? {
//    guard let data = userDefaults.data(forKey: defaultFileKey),
//      let file = try? JSONDecoder().decode(File.self, from: data) else {
//      Logger.info(
//        "No default file found"
//      )
//      return nil
//    }
//
//    Logger.info(
//      "Default file found."
//    )
//    return file
//  }
//
//  func addDefault(file: File) {
//    do {
//      let data = try JSONEncoder().encode(file)
//      userDefaults.set(data, forKey: defaultFileKey)
//    } catch {
//      fatalError("This should've never happened!!")
//    }
//  }
//
//  func addDataLocationMap(map: [String: String]) {
//    userDefaults.set(map, forKey: dataMapKey)
//  }
//
//  func getDataLocationMap() -> [String: String] {
//    guard let map = userDefaults
//            .dictionary(forKey: self.dataMapKey) as? [String: String] else {
//      return [String: String]()
//    }
//    return map
//  }

  func clearDefaultFile() {
    userDefaults.removeObject(forKey: defaultSheetKey)
  }
}

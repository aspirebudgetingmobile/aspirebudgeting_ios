//
//  AppDelegate.swift
//  Aspire Budgeting
//

import SwiftyBeaver
import UIKit

let Logger = SwiftyBeaver.self

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var logURL: URL {
    var url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
    url.appendPathComponent("aspire_budgeting.log")
    return url
  }

  fileprivate func setupLogger() {
    let console = ConsoleDestination()
    let file = FileDestination(logFileURL: logURL)

    console.format = "$DHH:mm:ss$d $L $M $X"
    file.format += " $X"

    Logger.addDestination(console)
    Logger.addDestination(file)
  }

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    UITableView.appearance().backgroundColor = .clear
    UITableViewCell.appearance().backgroundColor = .clear
    UITableView.appearance().separatorColor = .clear

    setupLogger()
    return true
  }

  // MARK: UISceneSession Lifecycle

  func application(
    _ application: UIApplication,
    configurationForConnecting connectingSceneSession: UISceneSession,
    options: UIScene.ConnectionOptions
  ) -> UISceneConfiguration {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return UISceneConfiguration(
      name: "Default Configuration",
      sessionRole: connectingSceneSession.role
    )
  }

  func application(
    _ application: UIApplication,
    didDiscardSceneSessions sceneSessions: Set<UISceneSession>
  ) {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called
    // shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they
    // will not return.
  }
}

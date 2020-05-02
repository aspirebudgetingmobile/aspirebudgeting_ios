//
//  SceneDelegate.swift
//  Aspire Budgeting
//

import Combine
import SwiftUI
import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?
  private let objectFactory = ObjectFactory()

  private var driveManager: GoogleDriveManager!
  private var sheetsManager: GoogleSheetsManager!
  private var localAuthorizationManager: LocalAuthorizationManager!
  private var stateManager: StateManager!

  private var stateManagerSink: AnyCancellable!

  lazy var userManager = {
    objectFactory.userManager
  }()

  func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    // Use this method to optionally configure and attach the UIWindow `window` to the provided
    // UIWindowScene `scene`.
    // If using a storyboard, the `window` property will automatically be initialized and attached
    // to the scene.
    // This delegate does not imply the connecting scene or session are new (see
    // `application:configurationForConnectingSceneSession` instead).

    objectFactory.bugTracker.start()

    if driveManager == nil {
      driveManager = objectFactory.driveManager
    }

    if sheetsManager == nil {
      sheetsManager = objectFactory.sheetsManager
    }

    if localAuthorizationManager == nil {
      localAuthorizationManager = objectFactory.localAuthorizationManager
    }

    if stateManager == nil {
      stateManager = objectFactory.stateManager
    }

    stateManagerSink = stateManager.$currentStatePublisher
      .sink(receiveValue: { [weak self] currentState in
        guard let weakSelf = self else { return }

        switch currentState {
        case .loggedOut:
          weakSelf.userManager.authenticateWithGoogle()

        case .verifiedGoogleUser:
          weakSelf.userManager.authenticateLocally()

        case .authenticatedLocally:
          weakSelf.sheetsManager.checkDefaultsForSpreadsheet()

        default:
          print("The current state is \(currentState)")
        }
      })

    // Create the SwiftUI view that provides the window contents.
    let contentView = ContentView()
      .environmentObject(userManager)
      .environmentObject(driveManager)
      .environmentObject(sheetsManager)
      .environmentObject(localAuthorizationManager)
      .environmentObject(stateManager)

    // Use a UIHostingController as window root view controller.
    if let windowScene = scene as? UIWindowScene {
      let window = UIWindow(windowScene: windowScene)
      window.rootViewController = UIHostingController(rootView: contentView)
      self.window = window
      window.makeKeyAndVisible()
    }
  }

  func sceneDidDisconnect(_ scene: UIScene) {
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the
    // scene connects.
    // The scene may re-connect later, as its session was not neccessarily discarded (see
    // `application:didDiscardSceneSessions` instead).
  }

  func sceneDidBecomeActive(_ scene: UIScene) {
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was
    // inactive.
    if stateManager.currentState == .needsLocalAuthentication ||
      stateManager.currentState == .localAuthFailed {
      userManager.authenticateLocally()
    }
  }

  func sceneWillResignActive(_ scene: UIScene) {
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
    NotificationCenter.default.post(
      name: Notification.Name("background"),
      object: nil,
      userInfo: nil
    )
  }

  func sceneWillEnterForeground(_ scene: UIScene) {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
    if stateManager.currentState == .needsLocalAuthentication ||
      stateManager.currentState == .localAuthFailed {
      userManager.authenticateLocally()
    }
  }

  func sceneDidEnterBackground(_ scene: UIScene) {
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state
    // information
    // to restore the scene back to its current state.
    NotificationCenter.default.post(
      name: Notification.Name("background"),
      object: nil,
      userInfo: nil
    )
  }
}

//
//  StateManagerTests.swift
//  Aspire BudgetingTests
//
//  Created by TeraMo Labs on 11/16/19.
//  Copyright © 2019 TeraMo Labs. All rights reserved.
//

@testable import Aspire_Budgeting
import XCTest

final class StateManagerTests: XCTestCase {
  func postNotification(notificationName: Notification.Name, userInfo: [AnyHashable: Any]? = nil) {
    let notification = Notification(name: notificationName, object: nil, userInfo: userInfo)
    NotificationCenter.default.post(notification)
  }

  func testStateManager() {
    let stateManager = StateManager()

    XCTAssertEqual(stateManager.currentState.value, .loggedOut)

    postNotification(notificationName: Notification.Name("background"))
    XCTAssertEqual(stateManager.currentState.value, .loggedOut)

    postNotification(notificationName: .authorizerUpdated)
    XCTAssertEqual(stateManager.currentState.value, .verifiedGoogleUser)

    postNotification(notificationName: Notification.Name("background"))
    XCTAssertEqual(stateManager.currentState.value, .verifiedGoogleUser)

    postNotification(notificationName: .hasSheetInDefaults)
    XCTAssertEqual(stateManager.currentState.value, .verifiedGoogleUser)

    var userInfo = [AnyHashable: Any]()
    userInfo[Notification.Name.authorizedLocally] = true

    postNotification(notificationName: .authorizedLocally, userInfo: userInfo)
    XCTAssertEqual(stateManager.currentState.value, .authenticatedLocally)

    postNotification(notificationName: Notification.Name("background"))
    XCTAssertEqual(stateManager.currentState.value, .needsLocalAuthentication)

    userInfo[Notification.Name.authorizedLocally] = false
    postNotification(notificationName: .authorizedLocally, userInfo: userInfo)
    XCTAssertEqual(stateManager.currentState.value, .localAuthFailed)

    postNotification(notificationName: .hasSheetInDefaults)
    XCTAssertEqual(stateManager.currentState.value, .localAuthFailed)

    userInfo[Notification.Name.authorizedLocally] = true
    postNotification(notificationName: .authorizedLocally, userInfo: userInfo)
    XCTAssertEqual(stateManager.currentState.value, .authenticatedLocally)

    postNotification(notificationName: .hasSheetInDefaults)
    XCTAssertEqual(stateManager.currentState.value, .hasDefaultSheet)
  }
}

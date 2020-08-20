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
    XCTAssertEqual(stateManager.currentState.value, .verifiedExternally)

    postNotification(notificationName: Notification.Name("background"))
    XCTAssertEqual(stateManager.currentState.value, .verifiedExternally)

    postNotification(notificationName: .hasSheetInDefaults)
    XCTAssertEqual(stateManager.currentState.value, .verifiedExternally)

    var userInfo = [AnyHashable: Any]()
    userInfo[Notification.Name.authorizedLocally] = true

    stateManager.processEvent(event: .authenticatedLocally(result: true))
    XCTAssertEqual(stateManager.currentState.value, .authenticatedLocally)

    stateManager.processEvent(event: .enteredBackground)
    XCTAssertEqual(stateManager.currentState.value, .needsLocalAuthentication)

    stateManager.processEvent(event: .authenticatedLocally(result: false))
    XCTAssertEqual(stateManager.currentState.value, .localAuthFailed)

    postNotification(notificationName: .hasSheetInDefaults)
    XCTAssertEqual(stateManager.currentState.value, .localAuthFailed)

    stateManager.processEvent(event: .authenticatedLocally(result: true))
    XCTAssertEqual(stateManager.currentState.value, .authenticatedLocally)

    postNotification(notificationName: .hasSheetInDefaults)
    XCTAssertEqual(stateManager.currentState.value, .hasDefaultSheet)
  }
}

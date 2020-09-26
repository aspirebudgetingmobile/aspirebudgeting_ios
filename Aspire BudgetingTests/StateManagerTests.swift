//
//  StateManagerTests.swift
//  Aspire BudgetingTests
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

    stateManager.processEvent(event: .enteredBackground)
    XCTAssertEqual(stateManager.currentState.value, .loggedOut)

    stateManager.processEvent(event: .verifiedExternally)
    XCTAssertEqual(stateManager.currentState.value, .verifiedExternally)

    stateManager.processEvent(event: .enteredBackground)
    XCTAssertEqual(stateManager.currentState.value, .verifiedExternally)

    stateManager.processEvent(event: .hasDefaultFile)
    XCTAssertEqual(stateManager.currentState.value, .verifiedExternally)

    stateManager.processEvent(event: .authenticatedLocally(result: true))
    XCTAssertEqual(stateManager.currentState.value, .authenticatedLocally)

    stateManager.processEvent(event: .enteredBackground)
    XCTAssertEqual(stateManager.currentState.value, .needsLocalAuthentication)

    stateManager.processEvent(event: .authenticatedLocally(result: false))
    XCTAssertEqual(stateManager.currentState.value, .localAuthFailed)

    stateManager.processEvent(event: .hasDefaultFile)
    XCTAssertEqual(stateManager.currentState.value, .localAuthFailed)

    stateManager.processEvent(event: .authenticatedLocally(result: true))
    XCTAssertEqual(stateManager.currentState.value, .authenticatedLocally)

    stateManager.processEvent(event: .hasDefaultFile)
    XCTAssertEqual(stateManager.currentState.value, .hasDefaultSheet)
  }
}

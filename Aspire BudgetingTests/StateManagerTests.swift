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
  let stateManager = StateManager()
  
  func postNotification(notificationName: Notification.Name, userInfo: [AnyHashable: Any]? = nil) {
    let notification = Notification(name: notificationName, object: nil, userInfo: userInfo)
    NotificationCenter.default.post(notification)
  }
  func testStateManager() {
    XCTAssertEqual(stateManager.currentState, StateManager.State.loggedOut)
    
    postNotification(notificationName: Notification.Name("background"))
    XCTAssertEqual(stateManager.currentState, StateManager.State.loggedOut)
    
    postNotification(notificationName: .authorizerUpdated)
    XCTAssertEqual(stateManager.currentState, StateManager.State.verifiedGoogleUser)
    
    postNotification(notificationName: Notification.Name("background"))
    XCTAssertEqual(stateManager.currentState, StateManager.State.verifiedGoogleUser)
    
    postNotification(notificationName: .hasSheetInDefaults)
    XCTAssertEqual(stateManager.currentState, StateManager.State.verifiedGoogleUser)
    
    var userInfo = [AnyHashable: Any]()
    userInfo[Notification.Name.authorizedLocally] = true
    
    postNotification(notificationName: .authorizedLocally, userInfo: userInfo)
    XCTAssertEqual(stateManager.currentState, StateManager.State.authenticatedLocally)
    
    postNotification(notificationName: Notification.Name("background"))
    XCTAssertEqual(stateManager.currentState, StateManager.State.needsLocalAuthentication)
    
    userInfo[Notification.Name.authorizedLocally] = false
    postNotification(notificationName: .authorizedLocally, userInfo: userInfo)
    XCTAssertEqual(stateManager.currentState, StateManager.State.localAuthFailed)
    
    postNotification(notificationName: .hasSheetInDefaults)
    XCTAssertEqual(stateManager.currentState, StateManager.State.localAuthFailed)
    
    userInfo[Notification.Name.authorizedLocally] = true
    postNotification(notificationName: .authorizedLocally, userInfo: userInfo)
    XCTAssertEqual(stateManager.currentState, StateManager.State.authenticatedLocally)
    
    postNotification(notificationName: .hasSheetInDefaults)
    XCTAssertEqual(stateManager.currentState, StateManager.State.hasDefaultSheet)
  }
  
}

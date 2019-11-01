//
//  MockNotificationCenter.swift
//  Aspire BudgetingTests
//
//  Created by TeraMo Labs on 11/1/19.
//  Copyright © 2019 TeraMo Labs. All rights reserved.
//

@testable import Aspire_Budgeting
import Foundation

final class MockNotificationCenter: AspireNotificationCenter {
  var notificationName = Notification.Name("")
  
  func post(name aName: NSNotification.Name, object anObject: Any?, userInfo aUserInfo: [AnyHashable: Any]?) {
    notificationName = aName
  }
}

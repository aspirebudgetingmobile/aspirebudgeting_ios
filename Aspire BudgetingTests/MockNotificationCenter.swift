//
//  MockNotificationCenter.swift
//  Aspire BudgetingTests
//

@testable import Aspire_Budgeting
import Foundation

final class MockNotificationCenter: AspireNotificationCenter {
  var notificationName = Notification.Name("")

  func post(
    name aName: NSNotification.Name,
    object anObject: Any?,
    userInfo aUserInfo: [AnyHashable: Any]?
  ) {
    notificationName = aName
  }
}

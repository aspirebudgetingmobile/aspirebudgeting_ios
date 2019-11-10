//
//  LocalAuthorizationManager.swift
//  Aspire Budgeting
//
//  Created by TeraMo Labs on 11/7/19.
//  Copyright © 2019 TeraMo Labs. All rights reserved.
//

import Foundation
import LocalAuthentication

extension Notification.Name {
  static let authorizedLocally = Notification.Name("authorizedLocally")
}

final class LocalAuthorizationManager: ObservableObject {
  private var isAuthorized = false
  
  let context = LAContext()
  
  func authenticateUserLocally() {
    context.localizedCancelTitle = "Cancel"
    
    var error: NSError?
    if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
      let reason = "Log in to your account"
      context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { [weak self] (success, _) in
        guard let weakSelf = self else {
          return
        }
        weakSelf.isAuthorized = success
        weakSelf.postNotification()
      }
    }
  }
  
  private func postNotification() {
    let userInfo = [Notification.Name.authorizedLocally: isAuthorized]
    NotificationCenter.default.post(name: .authorizedLocally, object: nil, userInfo: userInfo)
  }
}

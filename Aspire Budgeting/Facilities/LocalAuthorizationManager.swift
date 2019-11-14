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
  
  private var context: LAContext {
    return LAContext()
  }
  
  func authenticateUserLocally() {
    let context = self.context
    
    context.localizedCancelTitle = "Cancel"
    
    var error: NSError?
    if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
      let reason = "Log in to your account"
      context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { [weak self] (success, error) in
        guard let weakSelf = self else {
          return
        }
        
        if let error = error {
          print(error.localizedDescription)
        }
        weakSelf.isAuthorized = success
        weakSelf.postNotification()
        context.invalidate()
      }
    }
  }
  
  private func postNotification() {
    let userInfo = [Notification.Name.authorizedLocally: isAuthorized]
    NotificationCenter.default.post(name: .authorizedLocally, object: nil, userInfo: userInfo)
  }
}

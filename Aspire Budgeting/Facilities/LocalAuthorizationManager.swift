//
//  LocalAuthorizationManager.swift
//  Aspire Budgeting
//
//  Created by TeraMo Labs on 11/7/19.
//  Copyright © 2019 TeraMo Labs. All rights reserved.
//

import Foundation
import LocalAuthentication

final class LocalAuthorizationManager: ObservableObject {
  @Published public private(set) var isAuthorized = false
  
  let context = LAContext()
  
  func signOut() {
    isAuthorized = false
  }
  
  func authenticateUserLocally() {
    context.localizedCancelTitle = "Cancel"
    
    var error: NSError?
    if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
      let reason = "Log in to your account"
      context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { [weak self] (success, error) in
        guard let weakSelf = self else {
          return
        }
        
        DispatchQueue.main.async {
          if success {
            print("Success")
            weakSelf.isAuthorized = true
          } else {
            print(error?.localizedDescription ?? "Failed")
            weakSelf.isAuthorized = false
          }
        }
      }
    }
  }
}

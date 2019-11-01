//
//  MockAuthorizer.swift
//  Aspire BudgetingTests
//
//  Created by TeraMo Labs on 11/1/19.
//  Copyright © 2019 TeraMo Labs. All rights reserved.
//

@testable import Aspire_Budgeting
import Foundation
import GTMSessionFetcher

final class MockAuthorizer: NSObject, GTMFetcherAuthorizationProtocol {
  func authorizeRequest(_ request: NSMutableURLRequest?, delegate: Any, didFinish sel: Selector) {
    
  }
  
  func stopAuthorization() {
    
  }
  
  func stopAuthorization(for request: URLRequest) {
    
  }
  
  func isAuthorizingRequest(_ request: URLRequest) -> Bool {
    return false
  }
  
  func isAuthorizedRequest(_ request: URLRequest) -> Bool {
    return false
  }
  
  var userEmail: String?
}

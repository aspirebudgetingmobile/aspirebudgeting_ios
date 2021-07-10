//
//  MockAuthorizer.swift
//  Aspire BudgetingTests
//

import Foundation
import GTMSessionFetcher

final class MockAuthorizer: NSObject, GTMFetcherAuthorizationProtocol {
  func authorizeRequest(_ request: NSMutableURLRequest?, delegate: Any, didFinish sel: Selector) {}

  func stopAuthorization() {}

  func stopAuthorization(for request: URLRequest) {}

  func isAuthorizingRequest(_ request: URLRequest) -> Bool {
    false
  }

  func isAuthorizedRequest(_ request: URLRequest) -> Bool {
    false
  }

  var userEmail: String?
}

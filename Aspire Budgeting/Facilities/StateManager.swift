//
//  StateManager.swift
//  Aspire Budgeting
//
//  Created by TeraMo Labs on 11/9/19.
//  Copyright © 2019 TeraMo Labs. All rights reserved.
//

import Foundation

final class StateManager: ObservableObject {
  enum State: Equatable {
    case loggedOut
    case verifiedGoogleUser
    case authenticatedLocally
    case hasFullAccess
    case needsLocalAuthentication
  }
  
  @Published var currentState: State = .loggedOut
  
  private var authorizerObserver: NSObjectProtocol?
  private var localAuthObserver: NSObjectProtocol?
  
  init() {
    authorizerObserver =
      NotificationCenter.default
        .addObserver(forName: .authorizerUpdated,
                     object: nil,
                     queue: nil,
                     using: { _ in self.currentState = .verifiedGoogleUser})
    
    localAuthObserver =
    NotificationCenter.default
      .addObserver(forName: .authorizedLocally,
                   object: nil,
                   queue: nil, using: { _ in self.currentState = .authenticatedLocally})
  }
}

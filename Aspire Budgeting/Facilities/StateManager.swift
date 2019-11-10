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
    case localAuthFailed
    case hasFullAccess
    case needsLocalAuthentication
    case hasDefaultSheet
  }
  
  @Published var currentStatePublisher: State = .loggedOut
  var currentState: State = .loggedOut
  
  private var authorizerObserver: NSObjectProtocol?
  private var localAuthObserver: NSObjectProtocol?
  private var backgroundObserver: NSObjectProtocol?
  private var defaultSheetObserver: NSObjectProtocol?
  
  init() {
    authorizerObserver =
      NotificationCenter.default
        .addObserver(forName: .authorizerUpdated,
                     object: nil,
                     queue: nil,
                     using: { _ in
                      self.currentState = .verifiedGoogleUser
                      self.currentStatePublisher = .verifiedGoogleUser
                      
        })
    
    localAuthObserver =
      NotificationCenter.default
        .addObserver(forName: .authorizedLocally,
                     object: nil,
                     queue: OperationQueue.main, using: { notification in
                      guard let userInfo = notification.userInfo,
                        let success = userInfo[Notification.Name.authorizedLocally] as? Bool else {return}
                      
                      if success {
                        self.currentState = .authenticatedLocally
                        self.currentStatePublisher = .authenticatedLocally
                      } else {
                        self.currentState = .localAuthFailed
                        self.currentStatePublisher = .localAuthFailed
                      }
                      
        })
    
    backgroundObserver =
      NotificationCenter.default.addObserver(forName: Notification.Name("background"), object: nil, queue: nil, using: { _ in
        self.currentState = .needsLocalAuthentication
        self.currentStatePublisher = .needsLocalAuthentication
      })
    
    defaultSheetObserver = NotificationCenter.default.addObserver(forName: .hasSheetInDefaults, object: nil, queue: nil, using: { _ in
      self.currentState = .hasDefaultSheet
      self.currentStatePublisher = .hasDefaultSheet
    })
  }
}

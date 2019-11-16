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
    case needsLocalAuthentication
    case hasDefaultSheet
  }
  
  @Published var currentStatePublisher: State = .loggedOut
  public private(set) var currentState: State = .loggedOut
  
  private var authorizerObserver: NSObjectProtocol?
  private var localAuthObserver: NSObjectProtocol?
  private var backgroundObserver: NSObjectProtocol?
  private var defaultSheetObserver: NSObjectProtocol?
  
  private lazy var transitions: [State: Set<State>] = {
    var transitions = [State: Set<State>]()
    
    transitions[.loggedOut] = [.verifiedGoogleUser]
    transitions[.verifiedGoogleUser] = [.authenticatedLocally, .localAuthFailed]
    transitions[.authenticatedLocally] = [.localAuthFailed, .hasDefaultSheet, .needsLocalAuthentication]
    transitions[.hasDefaultSheet] = [.needsLocalAuthentication, .loggedOut]
    transitions[.needsLocalAuthentication] = [.authenticatedLocally, .localAuthFailed]
    transitions[.localAuthFailed] = [.authenticatedLocally]
    
    return transitions
  }()
  
  init() {
    authorizerObserver =
      NotificationCenter.default
        .addObserver(forName: .authorizerUpdated,
                     object: nil,
                     queue: nil,
                     using: { _ in
                      self.transition(to: .verifiedGoogleUser)
        })
    
    localAuthObserver =
      NotificationCenter.default
        .addObserver(forName: .authorizedLocally,
                     object: nil,
                     queue: OperationQueue.main, using: { notification in
                      guard let userInfo = notification.userInfo,
                        let success = userInfo[Notification.Name.authorizedLocally] as? Bool else {return}
                      
                      if success {
                        self.transition(to: .authenticatedLocally)
                      } else {
                        self.transition(to: .localAuthFailed)
                      }
                      
        })
    
    backgroundObserver =
      NotificationCenter.default.addObserver(forName: Notification.Name("background"), object: nil, queue: nil, using: { _ in
        self.transition(to: .needsLocalAuthentication)
      })
    
    defaultSheetObserver = NotificationCenter.default.addObserver(forName: .hasSheetInDefaults, object: nil, queue: nil, using: { _ in
      self.transition(to: .hasDefaultSheet)
    })
  }
  
  func transition(to nextState: State) {
    if canTransition(to: nextState) {
      self.currentState = nextState
      self.currentStatePublisher = nextState
    }
  }
  
  func canTransition(to nextState: State) -> Bool {
    guard let validTransitions = transitions[currentState] else {
      return false
    }
    
    return validTransitions.contains(nextState)
  }
}

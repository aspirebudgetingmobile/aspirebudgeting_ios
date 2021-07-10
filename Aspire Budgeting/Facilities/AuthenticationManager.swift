//
// AuthenticationManager.swift
// Aspire Budgeting
//

import Combine

class AuthenticationManager: ObservableObject {

  private let userManager: UserManager
  private var cancellables = Set<AnyCancellable>()

  @Published private(set) var user: User?

  public var isLoggedOut: Bool {
    user == nil
  }

  public init(userManager: UserManager) {
    self.userManager = userManager
  }
  
  func authenticateRemotely() {
    userManager
      .userPublisher
      .sink { user in
        self.user = user
      }
      .store(in: &cancellables)
    
    userManager.authenticate()
  }
}

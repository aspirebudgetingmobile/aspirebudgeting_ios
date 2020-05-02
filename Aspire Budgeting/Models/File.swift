//
//  File.swift
//  Aspire Budgeting
//
//  Created by TeraMo Labs on 10/24/19.
//  Copyright © 2019 TeraMo Labs. All rights reserved.
//

import Foundation

struct File: Identifiable, Codable {
  let id: String
  let name: String
}

extension File: Equatable {
  static func == (lhs: File, rhs: File) -> Bool {
    return (lhs.name == rhs.name) && (lhs.id == rhs.id)
  }
}

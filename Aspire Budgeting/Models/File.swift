//
//  File.swift
//  Aspire Budgeting
//
//  Created by TeraMo Labs on 10/24/19.
//  Copyright © 2019 TeraMo Labs. All rights reserved.
//

import Foundation
import GoogleAPIClientForREST

protocol AspireFile {
  var name: String? { get }
  var identifier: String? { get }
}

extension GTLRDrive_File: AspireFile {}

struct File: Identifiable, Codable {
  let id: String
  let name: String

  init(driveFile: AspireFile) {
    name = driveFile.name ?? "no file name"
    id = driveFile.identifier ?? ""
  }

  init(id: String, name: String) {
    self.name = name
    self.id = id
  }
}

extension File: Equatable {
  static func == (lhs: File, rhs: File) -> Bool {
    (lhs.name == rhs.name) && (lhs.id == rhs.id)
  }
}

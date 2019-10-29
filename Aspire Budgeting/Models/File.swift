//
//  File.swift
//  Aspire Budgeting
//
//  Created by TeraMo Labs on 10/24/19.
//  Copyright © 2019 TeraMo Labs. All rights reserved.
//

import Foundation
import GoogleAPIClientForREST

struct File: Identifiable {
  let id: String
  let name: String
  
  init(driveFile: GTLRDrive_File) {
    self.name = driveFile.name ?? "no file name"
    self.id = driveFile.identifier ?? ""
  }
}

extension File: Equatable {
  static func == (lhs: File, rhs: File) -> Bool {
    return (lhs.name == rhs.name) && (lhs.id == rhs.id)
  }
}

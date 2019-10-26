//
//  File.swift
//  Aspire Budgeting
//
//  Created by TeraMo Labs on 10/24/19.
//  Copyright © 2019 TeraMo Labs. All rights reserved.
//

import Foundation
import GoogleAPIClientForREST

class File: Identifiable {
  let name: String
  let identifier: String
  
  
  init(driveFile: GTLRDrive_File) {
    self.name = driveFile.name ?? "no file name"
    self.identifier = driveFile.identifier ?? ""
  }
}

extension File: Equatable {
  static func == (lhs: File, rhs: File) -> Bool {
    return (lhs.name == rhs.name) && (lhs.identifier == rhs.identifier)
  }
}

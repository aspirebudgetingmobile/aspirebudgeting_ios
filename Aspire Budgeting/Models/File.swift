//
//  File.swift
//  Aspire Budgeting
//
//  Created by TeraMo Labs on 10/24/19.
//  Copyright © 2019 TeraMo Labs. All rights reserved.
//

import Foundation

class File: Identifiable {
  let name: String
  let identifier: String
  
  
  init(name: String, identifier: String) {
    self.name = name
    self.identifier = identifier
  }
}

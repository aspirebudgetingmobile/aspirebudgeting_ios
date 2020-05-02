//
// AspireError.swift
// Aspire Budgeting
//

import Foundation

/// An error that can be used by the application.
protocol AspireError: Error {
  /// A description of the error.
  var description: String { get }
}

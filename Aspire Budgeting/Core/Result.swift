//
// Result.swift
// Aspire Budgeting
//

import Foundation

/// A generic result.
enum Result<T> {
  /// A successful result with the generic associated value.
  case success(T)
  /// An error result with the `AspireError` assocated value.
  case error(AspireError)
}

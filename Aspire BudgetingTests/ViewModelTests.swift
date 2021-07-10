//
// ViewModelTests.swift
// Aspire BudgetingTests
// swiftlint:disable empty_xctest_method overridden_super_call

@testable import Aspire_Budgeting
import XCTest

final class ViewModelTests: XCTestCase {

  var refreshCalled = false

  override func setUpWithError() throws {
    refreshCalled = false
  }

  func refresh() {
    refreshCalled = true
  }

  func testViewModelBasic() {
    let viewModel = ViewModel<Int>(refreshAction: refresh)

    XCTAssertNil(viewModel.error)
    XCTAssertNil(viewModel.dataProvider)
    viewModel.refresh()
    XCTAssertTrue(refreshCalled)
  }

  func testViewModelAdvanced() {
    var result: Result<Int> = .success(5)
    var viewModel = ViewModel<Int>(result: result, refreshAction: refresh)

    XCTAssertNil(viewModel.error)
    XCTAssertNotNil(viewModel.dataProvider)
    XCTAssertEqual(viewModel.dataProvider!, 5)
    viewModel.refresh()
    XCTAssertTrue(refreshCalled)

    result = .failure(GoogleDriveManagerError.inconsistentSheet)
    viewModel = ViewModel<Int>(result: result, refreshAction: refresh)

    XCTAssertNil(viewModel.dataProvider)
    XCTAssertNotNil(viewModel.error)
    XCTAssertEqual(GoogleDriveManagerError.inconsistentSheet,
                   viewModel.error! as! GoogleDriveManagerError)

    viewModel = ViewModel<Int>(result: nil, refreshAction: refresh)
    XCTAssertNil(viewModel.error)
    XCTAssertNil(viewModel.dataProvider)
  }
}

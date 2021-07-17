//
// DashboardViewModelTests.swift
// Aspire BudgetingTests
//

@testable import Aspire_Budgeting
import Combine
import XCTest

class DashboardViewModelTests: XCTestCase {

  let dashboardPublisher = PassthroughSubject<Dashboard, Error>()
  var cancellables = Set<AnyCancellable>()

  func test_dashboardPublishedSuccessfully() {
    let vm = DashboardViewModel(publisher: dashboardPublisher.eraseToAnyPublisher())
    let exp = XCTestExpectation()

    vm
      .$dashboard
      .dropFirst()
      .sink { dashboard in
        let dashboard = try! XCTUnwrap(dashboard)
        XCTAssertEqual(dashboard, MockProvider.dashboard)
        exp.fulfill()
      }
      .store(in: &cancellables)

    vm.refresh()
    dashboardPublisher.send(MockProvider.dashboard)

    wait(for: [exp], timeout: 1)

    XCTAssertEqual(vm.cardViewItems, MockProvider.cardViewItems2)
  }
}

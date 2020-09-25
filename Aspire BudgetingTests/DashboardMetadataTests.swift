//
//  DashboardGroupsAndCategoriesTests.swift
//  Aspire BudgetingTests
//

@testable import Aspire_Budgeting
import XCTest

final class DashboardMetadataTests: XCTestCase {
  var sampleData = [[String]]()

  override func setUp() {
    super.setUp()
    sampleData.append(["✦", "", "C1"])
    sampleData.append(["✧", "", "C1R1", "$10", "", "", "$5", "", "", "$15"])
    sampleData.append(["✧", "", "C1R2", "$10,000", "", "", "$5.089", "", "", "$15,700"])
    sampleData.append(["✦", "", "C2"])
    sampleData.append(["✧", "", "C2R1", "-$10", "", "", "$5.00", "", "", "$15"])
    sampleData.append(["✧", "", "C2R2", "$10,000.67", "", "", "$5.08", "", "", "$15,700"])
  }

  func testDashboardGroupsAndCategoriesParser() {
    let metadata = Dashboard(rows: sampleData)
    XCTAssertEqual(metadata.groupedAvailableTotal(idx: 0),
                   AspireNumber(stringValue: "$10,010.00",
                                decimalValue: 10010))

    XCTAssertEqual(metadata.groupedAvailableTotal(idx: 1),
                   AspireNumber(stringValue: "$9,990.67",
                                decimalValue: 9990.67))

    XCTAssertEqual(metadata.groupedBudgetedTotal(idx: 0),
                   AspireNumber(stringValue: "$15,715.00",
                                decimalValue: 15715))

    XCTAssertEqual(metadata.groupedBudgetedTotal(idx: 1),
                   AspireNumber(stringValue: "$15,715.00",
                                decimalValue: 15715))

    XCTAssertEqual(metadata.groupedSpentTotal(idx: 0),
                   AspireNumber(stringValue: "$10.09",
                                decimalValue: 10.089))

    XCTAssertEqual(metadata.groupedSpentTotal(idx: 1),
                   AspireNumber(stringValue: "$10.08",
                                decimalValue: 10.08))

  }
}

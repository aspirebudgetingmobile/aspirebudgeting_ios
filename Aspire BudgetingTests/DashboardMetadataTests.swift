//
//  DashboardGroupsAndCategoriesTests.swift
//  Aspire BudgetingTests
//
//  Created by TeraMo Labs on 11/17/19.
//  Copyright © 2019 TeraMo Labs. All rights reserved.
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
    let dgc = DashboardMetadata(rows: sampleData)
    XCTAssertEqual(
      dgc.groupedAvailableTotals,
      [
        AspireNumber(stringValue: "$10,010.00", decimalValue: 10010),
        AspireNumber(stringValue: "$9,990.67", decimalValue: 9990.67),
      ]
    )

    XCTAssertEqual(
      dgc.groupedBudgetedTotals,
      [
        AspireNumber(stringValue: "$15,715.00", decimalValue: 15715),
        AspireNumber(stringValue: "$15,715.00", decimalValue: 15715),
      ]
    )

    XCTAssertEqual(
      dgc.groupedSpentTotals,
      [
        AspireNumber(stringValue: "$10.09", decimalValue: 10.089),
        AspireNumber(stringValue: "$10.08", decimalValue: 10.08),
      ]
    )
  }
}

//
//  DashboardUITests.swift
//  MedalCase_Runkeeper
//
//  Created by Vibha on 2026-07-14.
//

import XCTest

final class DashboardUITests: XCTestCase {

    func test_dashboard_displaysWelcomeContent() {
        let app = XCUIApplication()
        app.launch()

        XCTAssertTrue(app.staticTexts["welcome_title"].waitForExistence(timeout: 3))
        XCTAssertTrue(app.staticTexts["welcome_subtitle"].exists)
    }

    func test_launchPerformance() throws {
        if #available(iOS 13.0, *) {
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}

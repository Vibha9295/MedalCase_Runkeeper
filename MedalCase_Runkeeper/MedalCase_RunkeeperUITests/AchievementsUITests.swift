//
//  AchievementsUITests.swift
//  MedalCase_Runkeeper
//
//  Created by Vibha on 2026-07-14.
//

import XCTest

final class AchievementsUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    func test_dashboard_showsViewAchievementsButton() {
        XCTAssertTrue(app.buttons["view_achievements_button"].waitForExistence(timeout: 3))
    }

    func test_navigatingToAchievements_showsHeaderAndSections() {
        app.buttons["view_achievements_button"].tap()

        XCTAssertTrue(app.staticTexts["achievements_title"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["section_personal_records"].exists)
        XCTAssertTrue(app.staticTexts["section_virtual_races"].exists)
    }

    func test_backButton_returnsToDashboard() {
        app.buttons["view_achievements_button"].tap()
        XCTAssertTrue(app.staticTexts["achievements_title"].waitForExistence(timeout: 5))

        app.buttons["back_button"].tap()

        XCTAssertTrue(app.buttons["view_achievements_button"].waitForExistence(timeout: 3))
    }

    func test_tappingUnlockedAchievement_showsShareButton() {
            app.buttons["view_achievements_button"].tap()
            _ = app.staticTexts["section_personal_records"].waitForExistence(timeout: 5)

            let cell = app.buttons["achievement_longest_run"]
            XCTAssertTrue(cell.waitForExistence(timeout: 5))
            cell.tap()

            XCTAssertTrue(app.buttons["share_progress_button"].waitForExistence(timeout: 3))
        }

    func test_optionsMenu_opensAndShowsShareAndHelp() {
        app.buttons["view_achievements_button"].tap()
        _ = app.staticTexts["achievements_title"].waitForExistence(timeout: 5)

        app.buttons["options_section_header"].tap()

        XCTAssertTrue(app.buttons["share_summary_button"].waitForExistence(timeout: 3))
        XCTAssertTrue(app.buttons["help_faq_button"].exists)
    }

    func test_optionsMenu_doneButtonDismissesSheet() {
        app.buttons["view_achievements_button"].tap()
        _ = app.staticTexts["achievements_title"].waitForExistence(timeout: 5)
        app.buttons["options_section_header"].tap()

        XCTAssertTrue(app.buttons["share_summary_button"].waitForExistence(timeout: 3))
        app.buttons["navigation_done"].tap()

        XCTAssertFalse(app.buttons["share_summary_button"].waitForExistence(timeout: 2))
    }

    func test_pullToRefresh_onAchievementsList_doesNotCrash() {
        app.buttons["view_achievements_button"].tap()
        let list = app.scrollViews.firstMatch
        XCTAssertTrue(list.waitForExistence(timeout: 5))

        let start = list.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.2))
        let end = list.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.8))
        start.press(forDuration: 0.05, thenDragTo: end)

        XCTAssertTrue(app.staticTexts["achievements_title"].waitForExistence(timeout: 5))
    }
}

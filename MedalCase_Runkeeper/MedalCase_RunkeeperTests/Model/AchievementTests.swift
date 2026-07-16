//
//  AchievementTests.swift
//  MedalCase_Runkeeper
//
//  Created by Vibha on 2026-07-14.
//

import XCTest
@testable import MedalCase_Runkeeper

final class AchievementTests: XCTestCase {

    func test_isUnlocked_trueWhenValueIsPresent() {
        let achievement = Achievement(
            nameKey: "achievement_longest_run",
            value: "05:12",
            imageName: "img",
            isVirtualRace: false
        )
        XCTAssertTrue(achievement.isUnlocked)
    }

    func test_isUnlocked_falseWhenValueIsNil() {
        let achievement = Achievement(
            nameKey: "achievement_marathon",
            value: nil,
            imageName: "img",
            isVirtualRace: false
        )
        XCTAssertFalse(achievement.isUnlocked)
    }

    func test_defaultInitializer_generatesUniqueIDs() {
        let a = Achievement(nameKey: "key", value: nil, imageName: "img", isVirtualRace: false)
        let b = Achievement(nameKey: "key", value: nil, imageName: "img", isVirtualRace: false)
        XCTAssertNotEqual(a.id, b.id)
    }

    func test_explicitID_isPreserved() {
        let id = UUID()
        let achievement = Achievement(
            id: id,
            nameKey: "key",
            value: nil,
            imageName: "img",
            isVirtualRace: false
        )
        XCTAssertEqual(achievement.id, id)
    }

    func test_localizedName_isNotEmpty() {
        let achievement = Achievement(
            nameKey: "achievement_fastest_5k",
            value: nil,
            imageName: "img",
            isVirtualRace: false
        )
        XCTAssertFalse(achievement.localizedName.isEmpty)
    }

    func test_shareSummary_handlesNilValueGracefully() {
        let achievement = Achievement(
            nameKey: "achievement_marathon",
            value: nil,
            imageName: "img",
            isVirtualRace: false
        )
        // Should handle nil gracefully and must never output the literal word "nil" in the string
        XCTAssertFalse(achievement.shareSummary.contains("nil"))
    }

    func test_hashable_equalAchievementsAreEqual() {
        let id = UUID()
        let a = Achievement(id: id, nameKey: "key", value: "1", imageName: "img", isVirtualRace: false)
        let b = Achievement(id: id, nameKey: "key", value: "1", imageName: "img", isVirtualRace: false)
        
        XCTAssertEqual(a, b)
        XCTAssertEqual(a.hashValue, b.hashValue)
    }
}

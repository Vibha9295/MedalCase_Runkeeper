//
//  AchievementCatalogTests.swift
//  MedalCase_Runkeeper
//
//  Created by Vibha on 2026-07-14.
//

import XCTest
@testable import MedalCase_Runkeeper

final class AchievementCatalogTests: XCTestCase {

    func test_personalRecords_isNotEmpty() {
        XCTAssertFalse(AchievementCatalog.personalRecords.isEmpty)
    }

    func test_virtualRaces_isNotEmpty() {
        XCTAssertFalse(AchievementCatalog.virtualRaces.isEmpty)
    }

    func test_personalRecords_areFlaggedCorrectly() {
        XCTAssertTrue(AchievementCatalog.personalRecords.allSatisfy { $0.isVirtualRace == false })
    }

    func test_virtualRaces_areFlaggedCorrectly() {
        XCTAssertTrue(AchievementCatalog.virtualRaces.allSatisfy { $0.isVirtualRace == true })
    }

    func test_personalRecords_containsExactlyOneLockedAchievement() {
        // Guards the "marathon not yet earned" sample-data assumption other
        // tests / previews implicitly rely on.
        let locked = AchievementCatalog.personalRecords.filter { !$0.isUnlocked }
        XCTAssertEqual(locked.count, 1)
        XCTAssertEqual(locked.first?.nameKey, "achievement_marathon")
    }

    func test_allNameKeys_areUnique() {
        let keys = (AchievementCatalog.personalRecords + AchievementCatalog.virtualRaces).map(\.nameKey)
        XCTAssertEqual(keys.count, Set(keys).count)
    }

    func test_allIDs_areUnique() {
        let ids = (AchievementCatalog.personalRecords + AchievementCatalog.virtualRaces).map(\.id)
        XCTAssertEqual(ids.count, Set(ids).count)
    }
}

//
//  AchievementsViewModelTests.swift
//  MedalCase_Runkeeper
//
//  Created by Vibha on 2026-07-14.
//

import XCTest
@testable import MedalCase_Runkeeper

@MainActor
final class AchievementsViewModelTests: XCTestCase {

    func test_initialState_isIdle() {
        let sut = AchievementsViewModel(service: MockAchievementService())
        guard case .idle = sut.uiState else {
            return XCTFail("Expected .idle, got \(sut.uiState)")
        }
    }

    func test_loadData_onSuccess_transitionsToLoaded() async {
        let mock = MockAchievementService()
        mock.feedToReturn = .fixture()
        let sut = AchievementsViewModel(service: mock)

        await sut.loadData()

        guard case let .loaded(personalRecords, virtualRaces) = sut.uiState else {
            return XCTFail("Expected .loaded, got \(sut.uiState)")
        }
        XCTAssertEqual(personalRecords.count, 2)
        XCTAssertEqual(virtualRaces.count, 1)
        XCTAssertEqual(mock.fetchCallCount, 1)
    }

    func test_loadData_onFailure_transitionsToFailed() async {
        let mock = MockAchievementService()
        mock.errorToThrow = StubError()
        let sut = AchievementsViewModel(service: mock)

        await sut.loadData()

        guard case .failed = sut.uiState else {
            return XCTFail("Expected .failed, got \(sut.uiState)")
        }
    }

    func test_loadData_calledTwiceWithFreshCache_doesNotRefetch() async {
        let mock = MockAchievementService()
        mock.feedToReturn = .fixture()
        let sut = AchievementsViewModel(service: mock)

        await sut.loadData()
        await sut.loadData() // Cache is fresh (< 300s old) -> should be a no-op.

        XCTAssertEqual(mock.fetchCallCount, 1)
    }

    func test_loadData_withForceRefresh_alwaysRefetches() async {
        let mock = MockAchievementService()
        mock.feedToReturn = .fixture()
        let sut = AchievementsViewModel(service: mock)

        await sut.loadData()
        await sut.loadData(forceRefresh: true)

        XCTAssertEqual(mock.fetchCallCount, 2)
    }

    func test_forceRefresh_replacesDataWithNewFeed() async {
        let mock = MockAchievementService()
        mock.feedToReturn = .fixture(personalRecords: [
            Achievement(nameKey: "achievement_longest_run", value: "01:00", imageName: "img", isVirtualRace: false)
        ])
        let sut = AchievementsViewModel(service: mock)
        await sut.loadData()

        mock.feedToReturn = .fixture(personalRecords: [
            Achievement(nameKey: "achievement_longest_run", value: "02:00", imageName: "img", isVirtualRace: false),
            Achievement(nameKey: "achievement_fastest_5k", value: "00:20", imageName: "img", isVirtualRace: false)
        ])
        await sut.loadData(forceRefresh: true)

        guard case let .loaded(personalRecords, _) = sut.uiState else {
            return XCTFail("Expected .loaded")
        }
        XCTAssertEqual(personalRecords.count, 2)
    }

    func test_backgroundRefresh_setsIsBackgroundRefreshingDuringFetch() async {
        let mock = MockAchievementService()
        mock.feedToReturn = .fixture()
        let sut = AchievementsViewModel(service: mock)
        await sut.loadData() // populate initial data so subsequent calls are "background" refreshes

        mock.delay = .milliseconds(50)
        let refreshTask = Task { await sut.loadData(forceRefresh: true) }

        try? await Task.sleep(for: .milliseconds(10))
        XCTAssertTrue(sut.isBackgroundRefreshing)

        await refreshTask.value
        XCTAssertFalse(sut.isBackgroundRefreshing)
    }

    func test_backgroundRefreshFailure_preservesExistingData() async {
        let mock = MockAchievementService()
        mock.feedToReturn = .fixture()
        let sut = AchievementsViewModel(service: mock)
        await sut.loadData()

        mock.errorToThrow = StubError()
        await sut.loadData(forceRefresh: true)

        guard case let .loaded(personalRecords, virtualRaces) = sut.uiState else {
            return XCTFail("Expected .loaded to be preserved, got \(sut.uiState)")
        }
        XCTAssertEqual(personalRecords.count, 2)
        XCTAssertEqual(virtualRaces.count, 1)
    }

    func test_initialLoadFailure_doesNotSetBackgroundRefreshingFlag() async {
        let mock = MockAchievementService()
        mock.errorToThrow = StubError()
        let sut = AchievementsViewModel(service: mock)

        await sut.loadData()

        XCTAssertFalse(sut.isBackgroundRefreshing)
    }

    func test_personalRecordsProgress_reflectsUnlockedCount() async {
        let mock = MockAchievementService()
        mock.feedToReturn = .fixture(personalRecords: [
            Achievement(nameKey: "a", value: "1", imageName: "img", isVirtualRace: false),
            Achievement(nameKey: "b", value: nil, imageName: "img", isVirtualRace: false),
            Achievement(nameKey: "c", value: "3", imageName: "img", isVirtualRace: false)
        ])
        let sut = AchievementsViewModel(service: mock)
        await sut.loadData()

        XCTAssertEqual(sut.personalRecordsProgress, String(localized: "progress_format \(2) \(3)"))
    }

    func test_personalRecordsProgress_isEmptyStringBeforeLoad() {
        let sut = AchievementsViewModel(service: MockAchievementService())
        XCTAssertEqual(sut.personalRecordsProgress, "")
    }

    func test_defaultInitializer_usesDefaultAchievementService() async {
       
        let sut = AchievementsViewModel()
        await sut.loadData()

        guard case let .loaded(personalRecords, _) = sut.uiState else {
            return XCTFail("Expected .loaded via DefaultAchievementService")
        }
        XCTAssertEqual(personalRecords.count, AchievementCatalog.personalRecords.count)
    }
}

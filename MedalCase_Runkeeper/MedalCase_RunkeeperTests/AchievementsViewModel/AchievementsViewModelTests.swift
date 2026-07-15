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
        await sut.loadData()

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

    func test_backgroundRefresh_setsIsBackgroundRefreshingDuringFetch() async {
        let mock = MockAchievementService()
        mock.feedToReturn = .fixture()
        let sut = AchievementsViewModel(service: mock)
        await sut.loadData()

        mock.delay = .milliseconds(50)
        let refreshTask = Task { await sut.loadData(forceRefresh: true) }

        try? await Task.sleep(for: .milliseconds(10))
        XCTAssertTrue(sut.isBackgroundRefreshing)

        await refreshTask.value
        XCTAssertFalse(sut.isBackgroundRefreshing)
    }
}

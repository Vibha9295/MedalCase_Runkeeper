//
//  AchievementServiceTests.swift
//  MedalCase_Runkeeper
//
//  Created by Vibha on 2026-07-14.
//

import XCTest
@testable import MedalCase_Runkeeper

@MainActor
final class AchievementServiceTests: XCTestCase {

    // MARK: - Achievement Service Tests

    func test_defaultService_returnsCatalogData() async throws {
        let service = DefaultAchievementService()
        let feed = try await service.fetchAchievements()

        XCTAssertEqual(feed.personalRecords.count, AchievementCatalog.personalRecords.count)
        XCTAssertEqual(feed.virtualRaces.count, AchievementCatalog.virtualRaces.count)
    }

    func test_defaultService_simulatesLatency() async throws {
        let service = DefaultAchievementService()
        let start = ContinuousClock.now
        _ = try await service.fetchAchievements()
        let elapsed = ContinuousClock.now - start

        XCTAssertGreaterThanOrEqual(elapsed, .milliseconds(750))
    }

    func test_achievementServiceError_hasLocalizedDescription() {
        let error = AchievementServiceError.network
        XCTAssertEqual(error.errorDescription, String(localized: "error_subtitle"))
    }

    // MARK: - Mock-Based Contract Tests

    func test_mockService_returnsInjectedFeed() async throws {
        let mock = MockAchievementService()
        mock.feedToReturn = .fixture()

        let feed = try await mock.fetchAchievements()

        XCTAssertEqual(feed.personalRecords.count, 2)
        XCTAssertEqual(feed.virtualRaces.count, 1)
        XCTAssertEqual(mock.fetchCallCount, 1)
    }

    func test_mockService_throwsInjectedError() async {
        let mock = MockAchievementService()
        let expectedError = StubError()
        mock.errorToThrow = expectedError

        do {
            _ = try await mock.fetchAchievements()
            XCTFail("Expected fetchAchievements to throw, but it succeeded")
        } catch let error as StubError {
            XCTAssertEqual(error, expectedError)
        } catch {
            XCTFail("Unexpected error type thrown: \(error)")
        }
    }

    func test_mockService_tracksCallCountAcrossMultipleFetches() async throws {
        let mock = MockAchievementService()
        
        _ = try await mock.fetchAchievements()
        _ = try await mock.fetchAchievements()
        _ = try await mock.fetchAchievements()

        XCTAssertEqual(mock.fetchCallCount, 3)
    }
}

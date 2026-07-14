//
//  MockAchievementService.swift
//  MedalCase_Runkeeper
//
//  Created by Vibha on 2026-07-14.
//

import Foundation
@testable import MedalCase_Runkeeper

final class MockAchievementService: AchievementService, @unchecked Sendable {

    // Feed returned by the next successful `fetchAchievements()` call.
    var feedToReturn = AchievementFeed(personalRecords: [], virtualRaces: [])

    // When set, `fetchAchievements()` throws this instead of returning data.
    var errorToThrow: Error?

    // Optional artificial delay before resolving, to simulate network
    // latency and let tests observe intermediate states (e.g. `.loading`).
    var delay: Duration = .zero

    // Number of times `fetchAchievements()` has been invoked.
    private(set) var fetchCallCount = 0

    // Optional hook invoked at the start of every call, useful for
    // asserting ordering/timing without racing the test.
    var onFetch: (() -> Void)?

    func fetchAchievements() async throws -> AchievementFeed {
        fetchCallCount += 1
        onFetch?()

        if delay > .zero {
            try await Task.sleep(for: delay)
        }

        if let errorToThrow {
            throw errorToThrow
        }

        return feedToReturn
    }
}

extension AchievementFeed {
    // Convenience fixture with a predictable mix of unlocked/locked items,
    // mirroring the shape of `AchievementCatalog` without depending on it.
    static func fixture(
        personalRecords: [Achievement] = [
            Achievement(nameKey: "achievement_longest_run", value: "05:12", imageName: "longest_run", isVirtualRace: false),
            Achievement(nameKey: "achievement_fastest_5k", value: nil, imageName: "fastest_5k", isVirtualRace: false)
        ],
        virtualRaces: [Achievement] = [
            Achievement(nameKey: "achievement_virtual_5k", value: "23:07", imageName: "virtual_5k_race", isVirtualRace: true)
        ]
    ) -> AchievementFeed {
        AchievementFeed(personalRecords: personalRecords, virtualRaces: virtualRaces)
    }
}

struct StubError: Error, Equatable {
    let message: String
    init(_ message: String = "stub failure") { self.message = message }
}

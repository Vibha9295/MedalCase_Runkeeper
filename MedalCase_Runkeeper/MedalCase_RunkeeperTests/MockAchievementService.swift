//
//  MockAchievementService.swift
//  MedalCase_Runkeeper
//
//  Created by Vibha on 2026-07-14.
//

import XCTest
import Foundation
@testable import MedalCase_Runkeeper

/// Safe, thread-safe testing errors.
struct StubError: LocalizedError, Equatable {
    var errorDescription: String? { "Simulated service error" }
}

/// Fully thread-safe, Swift 6 safe async Mock service.
final class MockAchievementService: AchievementService, @unchecked Sendable {
    private let lock = NSLock()
    
    var feedToReturn: AchievementFeed = AchievementFeed(personalRecords: [], virtualRaces: [])
    var errorToThrow: Error?
    var delay: Duration?
    
    private var _fetchCallCount = 0
    var fetchCallCount: Int {
        lock.withLock { _fetchCallCount }
    }

    func fetchAchievements() async throws -> AchievementFeed {
        lock.withLock {
            _fetchCallCount += 1
        }
        
        if let delay {
            try await Task.sleep(for: delay)
        }
        
        if let error = errorToThrow {
            throw error
        }
        
        return feedToReturn
    }
}

extension AchievementFeed {
    static func fixture(
        personalRecords: [Achievement] = [
            Achievement(nameKey: "rec_1", value: "10:00", imageName: "img1", isVirtualRace: false),
            Achievement(nameKey: "rec_2", value: nil, imageName: "img2", isVirtualRace: false)
        ],
        virtualRaces: [Achievement] = [
            Achievement(nameKey: "race_1", value: "25:00", imageName: "img3", isVirtualRace: true)
        ]
    ) -> AchievementFeed {
        AchievementFeed(personalRecords: personalRecords, virtualRaces: virtualRaces)
    }
}

//
//  AchievementService.swift
//  MedalCase_Runkeeper
//
//  Created by Vibha on 2026-07-14.
//

import Foundation

protocol AchievementService: Sendable {
    func fetchAchievements() async throws -> AchievementFeed
}

enum AchievementServiceError: LocalizedError {
    case network

    var errorDescription: String? {
        String(localized: "error_subtitle")
    }
}

/// Mock implementation standing in for a real network/backend call.
struct DefaultAchievementService: AchievementService {
    func fetchAchievements() async throws -> AchievementFeed {
        try await Task.sleep(for: .seconds(0.8)) // Simulated network latency.
        return AchievementFeed(
            personalRecords: AchievementCatalog.personalRecords,
            virtualRaces: AchievementCatalog.virtualRaces
        )
    }
}

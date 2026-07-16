//
//  AchievementsViewModel.swift
//  MedalCase_Runkeeper
//
//  Created by Vibha on 2026-07-14.
//

import Foundation
import Observation

@MainActor
@Observable
final class AchievementsViewModel {
    enum UIState {
        case idle
        case loading
        case loaded(personalRecords: [Achievement], virtualRaces: [Achievement])
        case failed(Error)
    }

    private(set) var uiState: UIState = .idle
    private(set) var isBackgroundRefreshing = false

    private let service: any AchievementService
    private let clock = ContinuousClock()
    private var lastFetchedInstant: ContinuousClock.Instant?
    private let cacheLifetime: Duration = .seconds(300)

    init(service: (any AchievementService)? = nil) {
        self.service = service ?? DefaultAchievementService()
    }

    var personalRecordsProgress: String {
        guard case let .loaded(records, _) = uiState else { return "" }
        let unlockedCount = records.filter(\.isUnlocked).count
        return String(localized: "progress_format \(unlockedCount) \(records.count)")
    }

    private var isCacheFresh: Bool {
        guard let lastFetchedInstant else { return false }
        return clock.now - lastFetchedInstant < cacheLifetime
    }

    func loadData(forceRefresh: Bool = false) async {
        if case .loaded = uiState {
            guard forceRefresh || !isCacheFresh else { return }
            await refreshInBackground()
        } else {
            await performInitialLoad()
        }
    }

    private func performInitialLoad() async {
        uiState = .loading
        do {
            let feed = try await service.fetchAchievements()
            apply(feed)
        } catch {
            uiState = .failed(error)
        }
    }

    private func refreshInBackground() async {
        isBackgroundRefreshing = true
        defer { isBackgroundRefreshing = false }

        do {
            let feed = try await service.fetchAchievements()
            apply(feed)
        } catch {
            // Background network dropouts are swallowed to avoid interrupting visible views
        }
    }

    private func apply(_ feed: AchievementFeed) {
        uiState = .loaded(personalRecords: feed.personalRecords, virtualRaces: feed.virtualRaces)
        lastFetchedInstant = clock.now
    }
}

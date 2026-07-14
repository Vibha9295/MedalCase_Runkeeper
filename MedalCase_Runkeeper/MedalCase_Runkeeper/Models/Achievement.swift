//
//  Achievement.swift
//  MedalCase_Runkeeper
//
//  Created by Vibha on 2026-07-14.
//

import Foundation

/// A single running achievement — either a personal record or a completed virtual race. value == nil means the achievement hasn't been earned yet.
struct Achievement: Identifiable, Hashable, Sendable {
    let id: UUID
    let nameKey: String
    let value: String?
    let imageName: String
    let isVirtualRace: Bool

    init(
        id: UUID = UUID(),
        nameKey: String,
        value: String?,
        imageName: String,
        isVirtualRace: Bool
    ) {
        self.id = id
        self.nameKey = nameKey
        self.value = value
        self.imageName = imageName
        self.isVirtualRace = isVirtualRace
    }

    var isUnlocked: Bool { value != nil }

    var localizedName: String {
        String(localized: LocalizedStringResource(stringLiteral: nameKey))
    }
}
// MARK: - Sharing

extension Achievement {
    // Share-sheet text for a single achievement. Lives here (rather than in the view) so it's unit-testable and reusable.
    var shareSummary: String {
        String(localized: "share_individual_achievement_summary \(localizedName) \(value ?? "")")
    }
}

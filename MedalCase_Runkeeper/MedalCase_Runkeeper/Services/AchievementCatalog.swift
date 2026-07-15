//
//  AchievementCatalog.swift
//  MedalCase_Runkeeper
//
//  Created by Vibha on 2026-07-14.
//

// MARK: - Sample Data

/// Mock catalog used by DefaultAchievementService. Separated from the service itself so it can be reused in SwiftUI previews and tests without pulling in networking/async concerns.
enum AchievementCatalog {
    static let personalRecords: [Achievement] = [
        Achievement(nameKey: "achievement_longest_run", value: "00:00", imageName: "longest_run", isVirtualRace: false),
        Achievement(nameKey: "achievement_highest_elevation", value: "2095 ft", imageName: "highest_elevation", isVirtualRace: false),
        Achievement(nameKey: "achievement_fastest_5k", value: "00:00", imageName: "fastest_5k", isVirtualRace: false),
        Achievement(nameKey: "achievement_fastest_10k", value: "00:00:00", imageName: "fastest_10k", isVirtualRace: false),
        Achievement(nameKey: "achievement_half_marathon", value: "00:00", imageName: "virtual_half_marathon_race", isVirtualRace: false),
        Achievement(nameKey: "achievement_marathon", value: nil, imageName: "fastest_marathon", isVirtualRace: false)
    ]

    static let virtualRaces: [Achievement] = [
        Achievement(nameKey: "achievement_virtual_half_marathon", value: "00:00", imageName: "virtual_half_marathon_race", isVirtualRace: true),
        Achievement(nameKey: "achievement_tokyo_ekiden", value: "00:00:00", imageName: "tokyo-hakone-ekiden-2020", isVirtualRace: true),
        Achievement(nameKey: "achievement_virtual_10k", value: "00:00:00", imageName: "virtual_10k_race", isVirtualRace: true),
        Achievement(nameKey: "achievement_hakone_ekiden", value: "00:00:00", imageName: "hakone_ekiden", isVirtualRace: true),
        Achievement(nameKey: "achievement_singapore_ekiden", value: "00:00:00", imageName: "mizuno_singapore_ekiden", isVirtualRace: true),
        Achievement(nameKey: "achievement_virtual_5k", value: "23:07", imageName: "virtual_5k_race", isVirtualRace: true),
        Achievement(nameKey: "achievement_virtual_marathon_race", value: nil, imageName: "virtual_marathon_race", isVirtualRace: true)
    ]
}

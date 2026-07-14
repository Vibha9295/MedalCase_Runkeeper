//
//  AchievementsListView.swift
//  MedalCase_Runkeeper
//
//  Created by Vibha on 2026-07-14.
//

import SwiftUI

struct AchievementsListView: View {
    let personalRecords: [Achievement]
    let virtualRaces: [Achievement]
    let personalRecordsProgress: String
    let onRefresh: () async -> Void

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                AchievementSectionGrid(
                    titleKey: "section_personal_records",
                    trailingContent: personalRecordsProgress,
                    achievements: personalRecords
                )

                AchievementSectionGrid(
                    titleKey: "section_virtual_races",
                    trailingContent: "",
                    achievements: virtualRaces
                )
            }
        }
        .scrollIndicators(.hidden)
        .refreshable {
            await onRefresh()
        }
    }
}


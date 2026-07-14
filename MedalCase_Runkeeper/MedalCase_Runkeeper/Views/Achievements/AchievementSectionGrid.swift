//
//  AchievementSectionGrid.swift
//  MedalCase_Runkeeper
//
//  Created by Vibha on 2026-07-14.
//

import SwiftUI

struct AchievementSectionGrid: View {
    let titleKey: LocalizedStringKey
    let trailingContent: String
    let achievements: [Achievement]

    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {
        SectionHeaderView(titleKey: titleKey, trailingContent: trailingContent)

        LazyVGrid(columns: columns, spacing: 20) {
            ForEach(achievements) { achievement in
                NavigationLink(destination: AchievementDetailView(achievement: achievement)) {
                    MedalCellView(achievement: achievement)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 16)
    }
}

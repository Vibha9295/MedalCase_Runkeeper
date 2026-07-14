//
//  MedalCellView.swift
//  MedalCase_Runkeeper
//
//  Created by Vibha on 2026-07-14.
//

import SwiftUI

struct MedalCellView: View {
    let achievement: Achievement

    var body: some View {
        VStack(spacing: 8) {
            Image(achievement.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 90, height: 90)
                .grayscale(achievement.isUnlocked ? 0.0 : 1.0)
                .opacity(achievement.isUnlocked ? 1.0 : 0.35)

            VStack(spacing: 4) {
                Text(achievement.localizedName)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(achievement.isUnlocked ? .primary : .secondary.opacity(0.5))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)

                Text(achievement.isUnlocked ? (achievement.value ?? "") : String(localized: "not_yet_earned_cell"))
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(achievement.isUnlocked ? .secondary : .secondary.opacity(0.3))
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 8)
        .frame(maxWidth: .infinity)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(achievement.localizedName)
        .accessibilityValue(
            achievement.isUnlocked
                ? String(localized: "status_earned") + ", " + (achievement.value ?? "")
                : String(localized: "status_locked")
        )
    }
}

#Preview {
    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
        MedalCellView(achievement: AchievementCatalog.personalRecords[0])
        MedalCellView(achievement: AchievementCatalog.personalRecords.last!)
    }
    .padding()
}

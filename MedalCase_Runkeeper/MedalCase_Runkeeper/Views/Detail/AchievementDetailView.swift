//
//  AchievementDetailView.swift
//  MedalCase_Runkeeper
//
//  Created by Vibha on 2026-07-14.
//

import SwiftUI

struct AchievementDetailView: View {
    let achievement: Achievement

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            summary
            Spacer()
            statusCard
            footerAction
        }
        .background(.background)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(achievement.isVirtualRace ? String(localized: "title_virtual_race") : String(localized: "title_personal_record"))
    }

    private var summary: some View {
        VStack(spacing: 16) {
            Image(achievement.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 180, height: 180)
                .grayscale(achievement.isUnlocked ? 0.0 : 1.0)
                .opacity(achievement.isUnlocked ? 1.0 : 0.4)
                .shadow(color: .black.opacity(achievement.isUnlocked ? 0.15 : 0.0), radius: 10, x: 0, y: 10)
                .accessibilityHidden(true)

            Text(achievement.localizedName)
                .font(.system(size: 24, weight: .bold))
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal, 24)

            if let value = achievement.value {
                Text("record_value_display \(value)")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(Color.brandTeal)
            } else {
                Text("not_yet_earned_detail")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var statusCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: achievement.isUnlocked ? "checkmark.circle.fill" : "lock.fill")
                    .foregroundStyle(achievement.isUnlocked ? .green : .secondary)
                    .accessibilityHidden(true)
                Text(achievement.isUnlocked ? "status_earned" : "status_locked")
                    .font(.headline)
            }

            Text(achievement.isVirtualRace ? "description_virtual_race" : "description_personal_record")
                .font(.system(size: 14))
                .foregroundStyle(.secondary)
                .lineSpacing(4)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: Layout.cardCornerRadius))
        .padding(.horizontal, Layout.screenHorizontalPadding)
    }

    @ViewBuilder
    private var footerAction: some View {
        if achievement.isUnlocked {
            ShareLink(item: achievement.shareSummary) {
                HStack(spacing: 8) {
                    Image(systemName: "square.and.arrow.up")
                    Text("share_progress_button")
                        .fontWeight(.bold)
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: Layout.secondaryButtonHeight)
                .background(Color.brandTeal, in: RoundedRectangle(cornerRadius: 12))
            }
            .padding(.horizontal, Layout.screenHorizontalPadding)
            .padding(.bottom, 32)
        } else {
            Button {
                dismiss()
            } label: {
                Text("back_button")
                    .fontWeight(.bold)
                    .foregroundStyle(Color.brandTeal)
                    .frame(maxWidth: .infinity)
                    .frame(height: Layout.secondaryButtonHeight)
                    .background(Color.brandTeal.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
            }
            .padding(.horizontal, Layout.screenHorizontalPadding)
            .padding(.bottom, 32)
        }
    }
}

#Preview("Unlocked") {
    NavigationStack {
        AchievementDetailView(achievement: AchievementCatalog.virtualRaces.last!)
    }
}

#Preview("Locked") {
    NavigationStack {
        AchievementDetailView(achievement: AchievementCatalog.personalRecords.last!)
    }
}

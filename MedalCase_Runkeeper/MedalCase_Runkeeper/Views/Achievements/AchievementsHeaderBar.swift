//
//  AchievementsHeaderBar.swift
//  MedalCase_Runkeeper
//
//  Created by Vibha on 2026-07-14.
//

import SwiftUI

struct AchievementsHeaderBar: View {
    let isRefreshing: Bool
    let onBack: () -> Void
    let onShowOptions: () -> Void

    var body: some View {
        ZStack {
            Color.brandTeal
                .ignoresSafeArea(edges: .top)

            HStack {
                Button(action: onBack) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                }
                .accessibilityLabel("back_button")
                .accessibilityIdentifier("back_button")

                Spacer()

                HStack(spacing: 8) {
                    Text("achievements_title")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(.white)
                        .accessibilityIdentifier("achievements_title")

                    if isRefreshing {
                        ProgressView()
                            .tint(.white)
                            .scaleEffect(0.8)
                            .accessibilityIdentifier("achievements_refresh_indicator") 

                    }
                }

                Spacer()

                Button(action: onShowOptions) {
                    Image(systemName: "ellipsis")
                        .rotationEffect(.degrees(90))
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                }
                .accessibilityLabel("options_section_header")
                .accessibilityIdentifier("options_section_header") 
            }
            .padding(.bottom, 10)
        }
        .frame(height: 56)
    }
}

#Preview {
    AchievementsHeaderBar(isRefreshing: true, onBack: {}, onShowOptions: {})
}

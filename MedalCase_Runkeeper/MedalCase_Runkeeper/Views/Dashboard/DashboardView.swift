//
//  DashboardView.swift
//  MedalCase_Runkeeper
//
//  Created by Vibha on 2026-07-14.
//

import SwiftUI

struct DashboardView: View {
    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Image(systemName: "figure.run.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .foregroundStyle(Color.brandTeal)
                .accessibilityHidden(true)

            VStack(spacing: 8) {
                Text("welcome_title")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(.primary)

                Text("welcome_subtitle")
                    .font(.system(size: 16))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }

            Spacer()

            NavigationLink(destination: AchievementsView()) {
                Label {
                    Text("view_achievements_button")
                        .fontWeight(.bold)
                } icon: {
                    Image(systemName: "trophy.fill")
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: Layout.primaryButtonHeight)
                .background(Color.brandTeal, in: RoundedRectangle(cornerRadius: Layout.primaryButtonHeight / 2))
                .padding(.horizontal, Layout.screenHorizontalPadding)
            }
            .padding(.bottom, 32)
        }
        .navigationTitle("dashboard_title")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack { DashboardView() }
}

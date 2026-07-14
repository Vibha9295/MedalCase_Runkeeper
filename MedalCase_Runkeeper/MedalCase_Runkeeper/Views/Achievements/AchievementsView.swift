//
//  AchievementsView.swift
//  MedalCase_Runkeeper
//
//  Created by Vibha on 2026-07-14.
//

import SwiftUI

struct AchievementsView: View {
    @State private var viewModel = AchievementsViewModel()
    @State private var isShowingOptionsMenu = false

    @Environment(\.dismiss) private var dismiss
    @Environment(\.openURL) private var openURL

    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()

            content
        }
        .safeAreaInset(edge: .top) {
            AchievementsHeaderBar(
                isRefreshing: viewModel.isBackgroundRefreshing,
                onBack: { dismiss() },
                onShowOptions: { isShowingOptionsMenu = true }
            )
        }
        .sheet(isPresented: $isShowingOptionsMenu) {
            OptionsMenuView(
                personalRecordsProgress: viewModel.personalRecordsProgress,
                onHelpTapped: openHelpFAQ
            )
            .presentationDetents([.fraction(0.35)])
            .presentationDragIndicator(.visible)
        }
        .navigationBarHidden(true)
        .task {
            await viewModel.loadData()
        }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.uiState {
        case .idle, .loading:
            ProgressView()
                .scaleEffect(1.2)
                .accessibilityLabel("Loading Achievements")

        case let .loaded(personalRecords, virtualRaces):
            AchievementsListView(
                personalRecords: personalRecords,
                virtualRaces: virtualRaces,
                personalRecordsProgress: viewModel.personalRecordsProgress,
                onRefresh: { await viewModel.loadData(forceRefresh: true) }
            )

        case .failed:
            ContentUnavailableView(
                String(localized: "error_title"),
                systemImage: "wifi.slash",
                description: Text("error_subtitle")
            )
        }
    }

    private func openHelpFAQ() {
        guard let helpURL = URL(string: "https://support.runkeeper.com/") else { return }
        openURL(helpURL)
    }
}

#Preview {
    NavigationStack { AchievementsView() }
}

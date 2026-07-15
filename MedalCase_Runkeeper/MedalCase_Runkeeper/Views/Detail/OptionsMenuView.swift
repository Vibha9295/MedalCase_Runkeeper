//
//  OptionsMenuView.swift
//  MedalCase_Runkeeper
//
//  Created by Vibha on 2026-07-14.
//

import SwiftUI

struct OptionsMenuView: View {
    let personalRecordsProgress: String
    let onHelpTapped: () -> Void

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 0) {
                Text("options_section_header")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 24)
                    .padding(.top, 24)
                    .padding(.bottom, 12)
                    .accessibilityIdentifier("options_menu_title")

                VStack(spacing: 0) {
                    ShareLink(item: String(localized: "share_all_records_summary \(personalRecordsProgress)")) {
                        optionRow(systemImage: "square.and.arrow.up", titleKey: "share_summary_button")
                    }
                    .accessibilityIdentifier("share_summary_button")
                    Divider()
                        .padding(.horizontal, 24)

                    Button {
                        dismiss()
                        onHelpTapped()
                    } label: {
                        optionRow(systemImage: "questionmark.circle", titleKey: "help_faq_button")
                    }
                    .accessibilityIdentifier("help_faq_button")
                }
                .background(Color(.secondarySystemBackground))
                .cornerRadius(14)
                .padding(.horizontal, 16)

                Spacer()
            }
            .background(Color(.systemBackground))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(String(localized: "navigation_done")) {
                        dismiss()
                    }
                    .fontWeight(.bold)
                    .foregroundStyle(Color.brandTeal)
                    .padding(.trailing, 0)
                    .accessibilityIdentifier("navigation_done")
                }
            }
        }
    }

    private func optionRow(systemImage: String, titleKey: LocalizedStringKey) -> some View {
        HStack(spacing: 12) {
            Image(systemName: systemImage)
                .font(.system(size: 18))
            Text(titleKey)
                .font(.system(size: 16, weight: .medium))
            Spacer()
        }
        .foregroundStyle(.primary)
        .padding(.vertical, 16)
        .padding(.horizontal, 24)
        .contentShape(Rectangle())
    }
}

#Preview {
    OptionsMenuView(personalRecordsProgress: "3/6", onHelpTapped: {})
}

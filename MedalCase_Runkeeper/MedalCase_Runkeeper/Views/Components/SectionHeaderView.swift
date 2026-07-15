//
//  SectionHeaderView.swift
//  MedalCase_Runkeeper
//
//  Created by Vibha on 2026-07-14.
//

import SwiftUI

struct SectionHeaderView: View {
    let titleKey: LocalizedStringKey
    let identifier: String
    let trailingContent: String

    var body: some View {
        HStack {
            Text(titleKey)
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(.secondary)
                .accessibilityIdentifier(identifier) 

            Spacer()
            Text(trailingContent)
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(.secondary)

        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity)
        .background(.secondary.opacity(0.1))
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    SectionHeaderView(titleKey: "section_personal_records", identifier: "section_personal_records", trailingContent: "3/6")
}

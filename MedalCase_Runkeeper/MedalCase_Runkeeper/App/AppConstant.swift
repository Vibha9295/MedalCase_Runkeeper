//
//  AppConstant.swift
//  MedalCase_Runkeeper
//
//  Created by Vibha on 2026-07-14.
//

import SwiftUI

extension Color {
    /// Primary brand accent used across headers, primary actions, and highlights.
    static let brandTeal = Color(red: 0.21, green: 0.73, blue: 0.82)
}

/// Layout constants shared by multiple screens. Keeping these in one place
/// avoids "magic number" drift when a designer tweaks spacing later.
enum Layout {
    static let screenHorizontalPadding: CGFloat = 24
    static let cardCornerRadius: CGFloat = 16
    static let primaryButtonHeight: CGFloat = 54
    static let secondaryButtonHeight: CGFloat = 50
}

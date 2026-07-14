//
//  AchievementFeed.swift
//  MedalCase_Runkeeper
//
//  Created by Vibha on 2026-07-14.
//

import Foundation

// Grouped result returned by an AchievementService. A named type reads better at call sites than an anonymous tuple and is easier to extend later
struct AchievementFeed: Sendable {
    let personalRecords: [Achievement]
    let virtualRaces: [Achievement]
}

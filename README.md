# MedalCase_Runkeeper
A SwiftUI-based Medal Case implementation for Runkeeper, featuring MVVM architecture, the Observation framework, and a modular design system with a dashboard entry point, a scrollable achievements list split into **Personal Records** and **Virtual Races**, per-achievement detail screens, and a share/help options menu.

Built with SwiftUI, the `Observation` framework (`@Observable`), and Swift Concurrency (`async`/`await`).

---
## Screenshots
<image width="150" src="https://github.com/user-attachments/assets/c4e737c1-4565-437c-b1cf-fd3723e633a3"/>
<image width="150" src="https://github.com/user-attachments/assets/a3a0d75b-587d-454a-9f0c-823af0b5391c"/>
<image width="150" src="https://github.com/user-attachments/assets/ffb01c40-9c79-4e8e-98b5-ecca670daef8"/>
<image width="150" src="https://github.com/user-attachments/assets/b58c741e-4695-40a8-bd84-2d312e45407d"/>
<image width="150" src="https://github.com/user-attachments/assets/ca53b4b2-6234-4f01-8e75-e778171d0d25"/>
<image width="150" src="https://github.com/user-attachments/assets/50d0d3e4-4fab-4001-8817-16c11ba5bf38"/>

## Requirements

- Xcode 15.4+
- iOS 17.0+ deployment target (required for `@Observable` / `Observation`)
- Swift 5.9+

---

## Project Structure

```
MedalCase_Runkeeper/
├── App/
│   └── ContentView.swift              # App entry point, wraps DashboardView in a NavigationStack
│   └── AppConstant.swift                    # Color.brandTeal + Layout constants shared across screens
├── Models/
│   └── Achievement.swift              # Achievement model, sample AchievementCatalog, shareSummary
├── Services/
│   └── AchievementService.swift       # AchievementService protocol, AchievementFeed, DefaultAchievementService
├── ViewModels/
│   └── AchievementsViewModel.swift    # UIState machine: idle/loading/loaded/failed + cache + background refresh
├── Views/
│   ├── DashboardView.swift
│   ├── AchievementsView.swift
│   ├── AchievementsHeaderBar.swift
│   ├── AchievementsListView.swift     # AchievementSectionGrid (personal records / virtual races)
│   ├── AchievementDetailView.swift
│   ├── MedalCellView.swift
│   ├── SectionHeaderView.swift
│   └── OptionsMenuView.swift
│
RunTests/
├── AchievementTests.swift
├── AchievementCatalogTests.swift
├── AchievementDetailDisplayTests.swift
├── AchievementServiceTests.swift
├── AchievementsViewModelTests.swift
└── MockAchievementService.swift       # Shared test + AchievementFeed.fixture()
│
RunUITests/
├── DashboardUITests.swift
├── AchievementsUITests.swift
└── AchievementDetailUITests.swift
```

---

## Architecture

**MV(VM)-lite.** Views stay declarative and dumb where possible; state and business rules live in `AchievementsViewModel`.

- **Model** — `Achievement` is a plain `Identifiable, Hashable, Sendable` struct. `value == nil` represents "not yet earned." Display-string logic that used to live inline in `AchievementDetailView` has been extracted into `Achievement+DetailDisplay.swift` so it's testable independently of SwiftUI rendering.
- **Service** — `AchievementService` is a protocol with one method, `fetchAchievements() async throws -> AchievementFeed`. `DefaultAchievementService` is a mock network layer (simulated latency, returns `AchievementCatalog`). Because it's a protocol, `AchievementsViewModel` can be constructed with any conforming type — production code gets the default, tests inject `MockAchievementService`.
- **ViewModel** — `AchievementsViewModel` is an `@Observable @MainActor` class exposing a `UIState` enum (`idle`, `loading`, `loaded(personalRecords:virtualRaces:)`, `failed(Error)`) plus `isBackgroundRefreshing`. Its `loadData(forceRefresh:)` method implements a small cache policy:
  - No cached data yet → full-screen `.loading`.
  - Cached data is fresh (< 5 minutes old) and `forceRefresh` is `false` → no-op.
  - Otherwise → silent background refresh that preserves on-screen content; background *failures* are intentionally swallowed rather than surfaced, so a flaky refresh never blanks out data the user was already looking at. Only a failure on the *initial* load produces `.failed`.
- **Views** — `AchievementsView` owns navigation/sheet state and switches on `UIState`. `AchievementsListView` composes two `AchievementSectionGrid`s to avoid duplicating the "header + `LazyVGrid`" block. `AchievementDetailView` and `MedalCellView` are pure presentation, driven entirely by an `Achievement`.

---

## Localization

All user-facing strings are string-catalog keys resolved via `String(localized:)` / `LocalizedStringKey`, e.g. `achievements_title`, `status_earned`, `progress_format`, `share_individual_achievement_summary`. Tests that assert on copy compare against `String(localized: "...")` rather than hardcoded English so they stay correct across locales.

---

## Testing

The test suite has two layers: fast, deterministic **unit tests** (model, service, view model, display logic) and **UI tests**.

---

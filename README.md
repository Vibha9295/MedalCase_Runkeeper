# MedalCase_Runkeeper
A SwiftUI-based Medal Case implementation for Runkeeper, featuring MVVM architecture, the Observation framework, and a modular design system with a dashboard entry point, a scrollable achievements list split into **Personal Records** and **Virtual Races**, per-achievement detail screens, and a share/help options menu.

Built with SwiftUI, the `Observation` framework (`@Observable`), and Swift Concurrency (`async`/`await`).

---
## Screenshots
<image width="200" src="https://github.com/user-attachments/assets/db8a663d-efe2-43cb-8d5b-d2be94859f21"/>
<image width="200" src="https://github.com/user-attachments/assets/c4e737c1-4565-437c-b1cf-fd3723e633a3"/>
<image width="200" src="https://github.com/user-attachments/assets/7fce3ef3-ac19-4156-9e1b-1b9854a17487"/>
<image width="200" src="https://github.com/user-attachments/assets/a3a0d75b-587d-454a-9f0c-823af0b5391c"/>
<image width="200" src="https://github.com/user-attachments/assets/84426702-1779-4c1e-8993-cf698a759d9e"/>
<image width="200" src="https://github.com/user-attachments/assets/ffb01c40-9c79-4e8e-98b5-ecca670daef8"/>
<image width="200" src="https://github.com/user-attachments/assets/c3319194-61ab-495c-a973-11ad46afc9eb"/>
<image width="200" src="https://github.com/user-attachments/assets/b58c741e-4695-40a8-bd84-2d312e45407d"/>

<image width="200" src="https://github.com/user-attachments/assets/c15c6cb6-7c42-4152-9123-4c5cffb2111b"/>
<image width="200" src="https://github.com/user-attachments/assets/2b0ff549-58c6-4c61-b542-ef6bea1f062c"/>
<image width="200" src="https://github.com/user-attachments/assets/ca53b4b2-6234-4f01-8e75-e778171d0d25"/>
<image width="200" src="https://github.com/user-attachments/assets/50d0d3e4-4fab-4001-8817-16c11ba5bf38"/>

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

The test suite has two layers: fast, deterministic **unit tests** (model, service, view model, display logic) and **UI tests** (XCUITest, driving the real app through the simulator).

### Unit tests — `RunTests`

| File | Covers |
|---|---|
| `AchievementTests.swift` | `isUnlocked`, ID generation/preservation, `localizedName`, `shareSummary` formatting (incl. nil value), `Hashable` conformance |
| `AchievementCatalogTests.swift` | Sample data sanity: non-empty sections, correct `isVirtualRace` flags, exactly one locked personal record, unique `nameKey`s/IDs |
| `AchievementDetailDisplayTests.swift` | Every computed property in `Achievement+DetailDisplay` across all four `(isVirtualRace, isUnlocked)` combinations |
| `AchievementServiceTests.swift` | `DefaultAchievementService` returns catalog-sized data and simulates latency; `AchievementServiceError.errorDescription`; `MockAchievementService` contract (returns injected feed, throws injected error, tracks call count) |
| `AchievementsViewModelTests.swift` | Full `UIState` state machine: idle → loading → loaded/failed, cache freshness (no refetch within 5 min), `forceRefresh` always refetching, background-refresh flag lifecycle, background failures preserving existing data, `personalRecordsProgress` string derivation, default-service wiring |
| `MockAchievementService.swift` | Shared `AchievementService` test double with configurable feed/error/delay/call count, plus an `AchievementFeed.fixture()` convenience and `StubError` |

---

## Known Simplifications

- `DefaultAchievementService` is a mock network layer (simulated 0.8s latency returning static `AchievementCatalog` data) — swap in a real backend call behind the same `AchievementService` protocol without touching the view model or views.
- The share sheet triggered by `ShareLink` is system UI (`UIActivityViewController`) and isn't part of the app's accessibility tree, so its UI test only asserts presentation, not content.

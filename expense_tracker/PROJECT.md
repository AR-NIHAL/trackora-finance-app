# Trackora — Expense Tracker App

Handoff / project documentation. This file is intended to give any developer or AI agent
a complete understanding of the project: what it is, how it is structured, what state
management it uses, what features exist, how persistence works, what has been done so far,
and what conventions must be followed.

---

## 1. Project Overview

- **App name:** Trackora
- **Package name:** `expense_tracker`
- **Type:** Flutter (Dart) mobile + web personal finance application
- **Location:** `expense_tracker/` inside the `trackora-finance-app` monorepo.
  - Sibling folders `fintrack/` and `trackkora/` are **separate projects — never touch them**.
- **Purpose:** Track income and expenses, set monthly category budgets, analyse spending,
  detect recurring subscriptions, set saving goals, and forecast cash flow.
- **Current status:** Feature-complete across four planned phases. `flutter analyze` is clean,
  all **13 tests pass** (see [Testing](#9-testing)).

### Environment

- Flutter **3.41.7**, Dart **3.11.5** (pubspec `environment: sdk: ^3.10.8`)
- Target platforms: **Mobile** (Android/iOS) and **Web**

### Dependencies (`pubspec.yaml`)

| Package               | Version   | Purpose                                       |
| --------------------- | --------- | --------------------------------------------- |
| `flutter_riverpod`    | `^3.3.1`  | State management (modern `Notifier` API)      |
| `intl`                | `^0.20.2` | Date/number formatting (`AppUtils`)           |
| `fl_chart`            | `^1.1.0`  | Charts (analytics bar chart, forecast line)   |
| `shared_preferences`  | `^2.5.3`  | Local persistence (JSON in prefs)             |
| `share_plus`          | `^12.0.1` | Share CSV / backup text                       |
| `flutter_lints`       | `^6.0.0`  | Linting (dev)                                 |

> After changing `pubspec.yaml`, always run `flutter pub get`.

---

## 2. Architecture & Patterns

The project follows a **feature-first folder structure** with a light layering of
`presentation` / `state` / `models`. There is no `provider`-based service locator;
state lives in Riverpod providers.

### Key conventions

- **State management:** Riverpod **v3 modern API only**. Every mutable store is a
  `Notifier<T>` exposed through a `NotifierProvider<NotifierT, T>`. Derived/read-only
  values are plain `Provider<T>`. **Legacy `StateNotifier` / `flutter_riverpod/legacy.dart`
  imports are banned** — all such code was migrated away.
- **Widgets** subscribe with `ref.watch(...)`; actions mutate with `ref.read(...notifier)`.
- **Presentation:** Screens are `ConsumerWidget` / `ConsumerStatefulWidget` /
  `StatelessWidget` composed from small widget files. Each screen keeps consistent
  styling: rounded cards (`BorderRadius.circular(18–28)`), soft `BoxShadow`, Material 3.
- **Currency:** always read from `settingsProvider` (`settings.currencyCode`, default `'USD'`)
  and formatted with `AppUtils.formatCurrency(amount, code)`.
- **No code comments are added** unless requested; code should be self-documenting.

### Navigation model

There is **no named route table**. Navigation is:

1. A bottom `NavigationBar` (`AppBottomNavBar`) switches between 5 root tabs via
   `MainShell` → `_buildCurrentScreen()`. Tab enum: `AppTabItem` (`app/router/app_tab_item.dart`).
2. Feature screens opened from Home quick actions (Insights / Subscriptions / Goals /
   Forecast) use `Navigator.push(MaterialPageRoute(...))`.
3. `Settings` → Export/Backup/Restore and Reset are handled inline.

Root widget tree:

```
main() → ProviderScope(child: ExpenseTrackerApp())
  ExpenseTrackerApp (ConsumerWidget) → MaterialApp(theme/darkTheme/themeMode)
    MainShell (StatefulWidget) → Scaffold(body: current tab screen, bottomNavigationBar)
```

---

## 3. Project Structure

```
expense_tracker/
├── lib/
│   ├── main.dart                                  # async init of storage, then runApp
│   ├── app/
│   │   ├── app.dart                               # ExpenseTrackerApp root widget
│   │   ├── router/app_tab_item.dart               # enum AppTabItem {home, analytics, add, budget, settings}
│   │   ├── shell/main_shell.dart                  # tab switch host
│   │   └── theme/
│   │       ├── app_colors.dart                    # AppColors constants
│   │       └── app_text_styles.dart               # AppTheme.lightTheme / darkTheme
│   ├── core/
│   │   ├── constants/app_constants.dart           # AppStrings (largely unused now)
│   │   ├── services/
│   │   │   ├── local_storage_service.dart         # shared_preferences persistence (singleton)
│   │   │   └── export_service.dart                # CSV + backup JSON builders
│   │   └── utils/app_utils.dart                   # currency/date formatting, id generation
│   ├── features/
│   │   ├── add_transaction/                       # transaction CRUD (core store)
│   │   ├── analytics/                             # spending charts & range filters
│   │   ├── budget/                                # monthly + category budgets
│   │   ├── forecast/                              # 90-day cash-flow projection
│   │   ├── goals/                                 # saving goals
│   │   ├── home/                                  # dashboard (balance, insights, recents, search)
│   │   ├── insights/                              # smart spending insights
│   │   ├── settings/                              # app settings + export/backup/restore
│   │   └── subscriptions/                         # recurring charge detection
│   └── shared/
│       ├── models/                                # data models (see §4)
│       └── widgets/                               # shared UI (bottom nav, cards, section titles)
└── test/
    ├── features_test.dart                         # 5 feature/logic tests
    ├── storage_test.dart                          # 4 persistence/serialization tests
    └── widget_test.dart                           # 4 end-to-end widget tests
```

Each feature folder follows this sub-structure (exact split varies per feature):

```
features/<feature>/
├── data/models/          # (rarely used — most models live in shared/models)
├── presentation/
│   ├── screens/
│   └── widgets/
└── state/
    ├── <feature>_provider.dart    # providers
    ├── <feature>_notifier.dart    # Notifier (mutation + persistence)
    └── <feature>_state.dart       # immutable state class
```

---

## 4. Data Models (`lib/shared/models/`)

| File                  | Class            | Notes                                                                 |
| --------------------- | ---------------- | --------------------------------------------------------------------- |
| `app_enums.dart`      | `TransactionType` | `{ income, expense }`                                                 |
|                       | `CategoryType`    | `{ income, expense }`                                                 |
| `transaction_model.dart` | `TransactionModel` | id, title, amount, type, categoryId, date, note, isRecurring; `toJson`/`fromJson`; value equality (`==`/`hashCode`); getters `isIncome`/`isExpense` |
| `budget_model.dart`   | `BudgetModel`     | id, categoryId, limitAmount, month, spentAmount; `remainingAmount`, `progress`, `isExceeded`; JSON round-trip |
| `category_model.dart` | `CategoryModel`   | id, name, iconName, type, color (static catalogue entries, not persisted) |
| `dummy_categories.dart` | `DummyCategories` | static catalogues: 8 expense + 5 income categories; `findById(id)`, `iconFor(name)`; categories have fixed hex colors |
| `saving_goal_model.dart` | `SavingGoal`    | id, name, targetAmount, savedAmount, deadline?; `remainingAmount`, `progress`, `isCompleted`; JSON round-trip |

**Category IDs** (used everywhere by transactions/budgets):

- Expense: `exp_food`, `exp_transport`, `exp_shopping`, `exp_bills`, `exp_health`,
  `exp_entertainment`, `exp_education`, `exp_other`
- Income: `inc_salary`, `inc_freelance`, `inc_bonus`, `inc_gift`, `inc_other`

> `BudgetModel` canonical location is `lib/shared/models/budget_model.dart`. A former
> duplicate at `lib/features/budget/data/models/budget_model.dart` was **deleted**.

---

## 5. State Management Details

### 5.1 Transactions (core store) — `features/add_transaction/state/`

- `transaction_notifier.dart` → `TransactionNotifier extends Notifier<TransactionState>`
  - `build()`: loads from storage; **if not seeded yet (`seeded_v1` flag false), writes a
    set of 7 dummy transactions** (dates relative to `DateTime.now()`, not fixed) and marks
    seeded. This is why a fresh install shows sample data.
  - Mutations: `addTransaction`, `updateTransaction`, `deleteTransaction`, `reset`,
    `replaceAll`. **Every mutation persists** via `_persist()`.
- `transaction_state.dart` → `TransactionState` (immutable `List<TransactionModel>`)
  - Derived getters: `totalIncome`, `totalExpense`, `totalBalance`,
    `totalTransactionCount`, `sortedByDateDesc`, `recentTransactions` (top 5),
    `expenses`, `spentByCategory`, `incomeByCategory()`, `recurringCandidates`
    (same title+amount across ≥2 distinct months), `incomeInMonth`/`expenseInMonth`.
- `transaction_provider.dart` → providers:
  - `transactionProvider` (NotifierProvider)
  - Derived: `totalBalanceProvider`, `totalIncomeProvider`, `totalExpenseProvider`,
    `recentTransactionsProvider`, `spentByCategoryProvider`,
    `currentMonthIncomeProvider`, `currentMonthExpenseProvider`,
    `recurringCandidatesProvider`.

### 5.2 Budget — `features/budget/state/`

- `BudgetNotifier` (`budget_notifier.dart`) → `BudgetState` (`budget_state.dart`)
  - Mutations: `setBudget` (upsert by id), `deleteBudget`, `reset`, `replaceAll`; each persists.
  - `BudgetState.forMonth(DateTime)` filters budgets to a given month.
- `budget_provider.dart` providers:
  - `budgetProvider` (NotifierProvider)
  - `currentMonthBudgetsProvider` (budgets for current month)
  - `budgetStatusListProvider` → `List<BudgetStatusItem>` — joins budgets with
    `spentByCategoryProvider` to compute `spentAmount`, `remainingAmount`, `progress`,
    `isExceeded`.
  - `totalMonthlyBudgetLimitProvider`, `totalMonthlyBudgetSpentProvider`,
    `totalMonthlyBudgetRemainingProvider`.

### 5.3 Settings — `features/settings/state/settings_provider.dart`

- `SettingsState`: `isDarkMode`, `currencyCode` (default `'USD'`), `notificationsEnabled`.
  JSON round-trip. Persisted on every change.
- `SettingsNotifier`: `toggleDarkMode`, `setCurrency`, `setNotificationsEnabled`.
- `themeModeProvider` → `Provider<ThemeMode>` mapping `isDarkMode` → dark/light.

### 5.4 Analytics — `features/analytics/state/analytics_provider.dart`

- `AnalyticsRange` enum `{ week, month, year }`; `analyticsRangeProvider`
  (`AnalyticsRangeNotifier`, default `month`).
- Derived providers:
  - `filteredExpenseTransactionsProvider` — expense-only transactions within range.
  - `rangeTotalExpenseProvider`, `rangeTransactionCountProvider`.
  - `rangeCategoryTotalsProvider` — category→total, sorted desc.
  - `rangeTopCategoryProvider`.
  - `spendingTrendProvider` → `List<SpendingPoint>` — 7 days (week), 4 week buckets (month),
    12 months (year).

### 5.5 Insights — `features/insights/state/insights_provider.dart`

- `insightsProvider` → `List<Insight>` (`icon`, `color`, `title`, `message`) computed from
  transactions. Generates: top spending category, month-over-month change,
  biggest expense, no-spend streak, savings rate, recurring charges found.

### 5.6 Subscriptions — `features/subscriptions/state/subscriptions_provider.dart`

- `subscriptionsProvider` → `List<SubscriptionItem>`: groups expenses by
  `title.lowercase | amount.toFixed(2)`; flags recurring when `isRecurring` is true on any
  member **or** the group spans ≥2 distinct months. Sorted by next occurrence.
- `upcomingRecurringExpenseProvider` → total amount of subscriptions due within the current month.

### 5.7 Goals — `features/goals/state/goal_provider.dart`

- `GoalNotifier` → `GoalState` (`List<SavingGoal>`); mutations `addGoal`, `updateGoal`,
  `deleteGoal`, `contribute`, `withdraw`, `replaceAll`, `reset`; each persists.
- `totalSavedInGoalsProvider` → sum of `savedAmount`.

### 5.8 Forecast — `features/forecast/state/forecast_provider.dart`

- `forecastProvider` → `List<ForecastPoint>` (91 points, today + 90 days). Starts from
  `totalBalanceProvider`, adds each recurring income on its day-of-month, subtracts each
  subscription amount on its next-occurrence day (matching logic: same day-of-month and a
  different month).
- `forecastSummaryProvider` → record `(double, double, double)` = projected balance at
  day 30, 60, 90.

---

## 6. Persistence (`lib/core/services/local_storage_service.dart`)

- Singleton: `LocalStorageService.instance` (static `SharedPreferences? _prefs`).
- `main()` calls `await LocalStorageService.init()` **before** `runApp` — this is critical
  because notifiers read prefs in their `build()`.
- Storage keys (all JSON strings inside shared_preferences):

  | Key                | Contents                                    |
  | ------------------ | ------------------------------------------- |
  | `transactions_v1`  | JSON array of `TransactionModel.toJson()`   |
  | `budgets_v1`       | JSON array of `BudgetModel.toJson()`        |
  | `settings_v1`      | JSON object of `SettingsState.toJson()`     |
  | `goals_v1`         | JSON array of `SavingGoal.toJson()`         |
  | `seeded_v1`        | bool flag controlling dummy-data seeding    |

- API: `getTransactions/saveTransactions`, `getBudgets/saveBudgets`,
  `getSettings/saveSettings`, `getGoals/saveGoals`, `isSeeded`, `markSeeded`.
- **Migration/versioning note:** keys are suffixed `_v1`. If the schema changes, bump the
  suffix and handle old keys, otherwise `fromJson` may throw on stale data.

---

## 7. Services & Utilities

### `lib/core/services/export_service.dart`

- `ExportService.buildCsv(List<TransactionModel>)` — header `Title,Amount,Type,Category,Date,Note`;
  sorts ascending by date; escapes commas/quotes/newlines; category resolved via `DummyCategories`.
- `ExportService.buildBackupJson({transactions, budgets, goals})` — JSON object
  `{ app: 'trackora', version: 1, exportedAt, transactions, budgets, goals }`.

### `lib/core/utils/app_utils.dart`

- `AppUtils.formatCurrency(double, String currencyCode)` — `NumberFormat.simpleCurrency(name: code)`,
  fallback to `##,##0.00` on error.
- `AppUtils.formatDate(DateTime)` → `MMM d, yyyy`.
- `AppUtils.formatFullDate(DateTime)` → `EEE, MMM d, yyyy`.
- `AppUtils.generateId()` → timestamp-microseconds + random suffix string.

> ⚠️ This file was accidentally deleted then restored (the git HEAD copy was empty; the real
> content was reconstructed from its call sites). It now lives at `core/utils/app_utils.dart`
> and is widely imported — **do not delete or rename it**.

---

## 8. Features & Screens

### Root tabs (`MainShell`)

| Tab      | Screen                     | Purpose                                             |
| -------- | -------------------------- | --------------------------------------------------- |
| Home     | `HomeScreen`               | Dashboard                                           |
| Analytics| `AnalyticsScreen`          | Spending analysis                                   |
| Add      | `AddTransactionScreen`     | Create a transaction                                |
| Budget   | `BudgetScreen`             | Monthly + category budgets                          |
| Settings | `SettingsScreen`           | Preferences, export/backup/restore                  |

### Home (`features/home/`)

- `BalanceSummaryCard` — total balance + this-month income/expense (uses `totalBalanceProvider`,
  `currentMonthIncomeProvider`, `currentMonthExpenseProvider`).
- `HomeQuickActions` — 4 tappable shortcuts (Insights, Subscriptions, Goals, Forecast) that
  `Navigator.push` their screens.
- `BudgetAlertBanner` — shows the first at-risk category budget (≥80% used or exceeded).
  **Watches `budgetProvider` and `spentByCategoryProvider` directly** (see Known Issues §11 for
  why this matters).
- `InsightsPreview` — top 3 insights with "See All" → `InsightsScreen`.
- `HomeSearchField` + `RecentTransactionsSection` — filters transactions by title/note,
  shows top 8.
- `RecentTransactionCard` — category icon + title + date + signed amount.

### Add Transaction (`features/add_transaction/`)

- Form with: type selector (expense/income), title, amount, category dropdown (filtered by
  type), date picker, **Recurring switch**, note field, save button.
- Validation via `Form`/`TextFormField` validators + snackbars for amount/category.
- On save: `AppUtils.generateId()` → `ref.read(transactionProvider.notifier).addTransaction(tx)`
  → snackbar "Transaction saved" → resets form.

### Budget (`features/budget/`)

- `MonthlyBudgetSummaryCard` — total limit/spent/remaining + progress bar (orange ≥80%,
  red exceeded).
- `CategoryBudgetSection` → `CategoryBudgetCard` list with per-card edit/delete; "Add"
  opens `BudgetFormDialog` (category + monthly limit; budget id = `{categoryId}_{year}_{month}`).
- Empty state prompts to add the first budget.

### Analytics (`features/analytics/`)

- `AnalyticsFilterTabs` (Week/Month/Year) drives `analyticsRangeProvider`.
- `SpendingOverviewCard` (total spending + transaction count in range).
- `AnalyticsChartPlaceholder` — fl_chart `BarChart` of `spendingTrendProvider`; shows
  "No spending in this period" when empty.
- `CategorySpendingSection` → ranked category cards.

### Insights (`features/insights/`)

- `InsightsScreen` — full list of generated insights (empty state text if none).

### Subscriptions (`features/subscriptions/`)

- `SubscriptionsScreen` — "Upcoming recurring charges" total + detected recurring items
  (icon, title, next date, amount in red).

### Goals (`features/goals/`)

- `GoalsScreen` — list of `SavingGoal` cards: progress ring (%, green when complete),
  saved/to-go amounts, deadline; menu edit/delete; Contribute/Withdraw buttons.
- `GoalFormDialog` (name, target, optional deadline) and `ContributeDialog`
  (amount; `isWithdraw` variant).

### Forecast (`features/forecast/`)

- `ForecastScreen` — 30/60/90-day metric cards + fl_chart `LineChart` of projected balance;
  informational footnote about assumptions.

### Settings (`features/settings/`)

- Dark Mode switch, Currency dropdown (`USD/BDT/EUR/GBP/INR`), Notifications switch,
  Reset Data (confirm dialog → resets transactions, budgets, goals).
- **Export Transactions (CSV)** → `SharePlus.instance.share(ShareParams(text: csv, subject: ...))`
  (share_plus v12 API).
- **Create Backup** → shares `buildBackupJson(...)`.
- **Restore from Backup** → reads clipboard JSON, validates `transactions`/`budgets` keys,
  replaces all three stores. Uses `ScaffoldMessenger.of(context)` captured **before** awaits
  (guards against `use_build_context_synchronously`).

---

## 9. Testing

Run checks:

```
flutter analyze          # must be clean
flutter test             # 13 tests, all must pass
```

| File                  | Count | Coverage                                                            |
| --------------------- | ----- | ------------------------------------------------------------------- |
| `test/storage_test.dart` | 4   | JSON round-trips (transaction, budget), persist/read, seed flag. Uses `SharedPreferences.setMockInitialValues({})` + `await LocalStorageService.init()` in `setUp`. |
| `test/features_test.dart` | 5  | CSV export header/rows, backup JSON round-trip, subscription detection (`ProviderContainer`), goals add/contribute, category lookup. |
| `test/widget_test.dart`  | 4   | Render home with balance, tab navigation, form validation, add→home reflects. Pumps `ProviderScope(child: ExpenseTrackerApp())`. |

**Test gotchas:**

- Widget tests **must not** rely on `main()` having run; they pump `ExpenseTrackerApp`
  directly. Providers read `LocalStorageService` which is fine because widget tests run inside
  a `TestWidgetsFlutterBinding` with mocked prefs.
- The seeded dummy data depends on `DateTime.now()`, so assertions are written against
  stable text like "Total Balance", not amounts.

---

## 10. Work Completed So Far (History / Handoff)

The project was upgraded in **phases**. Everything below is complete:

### Phase 1 — Core features working
- Rebuilt state layer with modern Riverpod `Notifier` API; removed legacy
  `StateNotifier`/`legacy.dart` and old `add_transaction_provider.dart` /
  `app/theme/theme_provider.dart`.
- Add Transaction screen fully functional (validation, type selector, category dropdown,
  date picker, save → provider + snackbar).
- Home dashboard live from providers (balance card, search, recent transactions).
- Budget tab: monthly summary, category budgets, set/edit dialog, progress colors.
- Analytics tab: week/month/year filter, fl_chart bar chart, overview + category breakdown.
- Settings: dark mode wired to theme, currency, notifications switch, reset dialog.

### Phase 2 — Persistence
- `LocalStorageService` (shared_preferences + JSON) for transactions, budgets, settings;
  `seeded_v1` flag with relative-date dummy seed data.
- `toJson`/`fromJson` added to `TransactionModel` and `BudgetModel`.
- Every notifier persists on each change; `main()` awaits `LocalStorageService.init()`.
- Added `test/storage_test.dart` (4 tests).

### Phase 3 — Unique features (complete)
- **Smart Insights** (`insights/`), **Recurring/Subscription manager** (`subscriptions/`),
  **Budget alerts** (`budget_alert_banner`), **Saving goals** (`goals/`),
  **Cash-flow forecast** (`forecast/`).
- Home: quick actions, budget alert banner, insights preview.
- Add Transaction gained a Recurring switch.
- Settings: Export CSV, Create Backup, Restore from clipboard (share_plus v12 API).
- Added `SavingGoal` model with JSON round-trip; all new providers persist.
- Fixed an e2e test failure: `BudgetAlertBanner` previously watched the multi-level derived
  chain `budgetAlertsProvider → budgetStatusListProvider → spentByCategoryProvider` which
  triggered a Riverpod `setState()/markNeedsBuild()` error during widget build. It now
  watches `budgetProvider` + `spentByCategoryProvider` directly and computes alerts inline;
  the old `budget_alerts_provider.dart` was deleted.
- Added `test/features_test.dart` (5 tests). Total tests: 13.

### Phase 4 — Cleanup (complete)
- Deleted dead code after verifying zero references:
  - `lib/app/router/app_router.dart` (duplicate shell concept — `main_shell.dart` is the real one)
  - `lib/features/add_transaction/presentation/widgets/transaction_form.dart`
  - `lib/features/{home,analytics,settings}/data/models/*_model.dart` (dead models)
  - `lib/features/budget/data/models/budget_model.dart` (duplicate of `shared/models`)
  - Removed orphaned empty `data/` directories.
- **⚠️ `core/utils/app_utils.dart` was initially misidentified as dead and deleted, then
  restored/reconstructed. It IS used (currency/date formatting everywhere).**

### Current verification status
- `flutter analyze`: **No issues found** (6s).
- `flutter test`: **13/13 pass**.

---

## 11. Known Issues / Gotchas / Conventions to Respect

1. **Riverpod build-time invalidation (regression risk):** derived `Provider`s that chain
   two or more levels off a mutable `NotifierProvider` can throw
   `setState() or markNeedsBuild()` when state mutates during a widget build (happens in
   widget tests). Prefer watching source notifiers directly (as `BudgetAlertBanner` does) or
   pumping extra frames in tests.
2. **`AppUtils` is load-bearing** — see §7 note. Never delete it.
3. **Storage schema versioning:** keys are `_v1`. Bump suffix + migrate when the JSON schema
   of any model changes, or old installs will break on `fromJson`.
4. **No comments policy:** do not add code comments unless asked; keep code self-documenting.
5. **Never touch sibling projects** (`fintrack/`, `trackkora/`).
6. **`flutter pub get` after pubspec changes.**
7. **Seeding:** fresh installs get dummy transactions. To see "empty" behaviour in tests or
   dev, the seed flag logic in `TransactionNotifier.build()` is the single place to change.
8. **Windows shell:** when running commands, use PowerShell (no `&&` chaining; use
   `;` or `if ($?)`).
9. **Git commit style:** lowercase conventional commits, e.g. `feat: add the budget section`.

---

## 12. Quick Reference — Where Things Live

| Question                              | Answer                                             |
| ------------------------------------- | -------------------------------------------------- |
| Where is the transaction store?       | `lib/features/add_transaction/state/`              |
| Where is persistence?                 | `lib/core/services/local_storage_service.dart`     |
| Where do categories come from?        | `lib/shared/models/dummy_categories.dart`          |
| How do I add a new screen?            | New feature dir under `lib/features/`, navigate with `MaterialPageRoute`. |
| How do I add a provider?              | Add to the feature's `state/<feature>_provider.dart`; mutating ones become `Notifier` + `NotifierProvider`. |
| Where are the settings/export actions?| `lib/features/settings/presentation/screens/settings_screen.dart` |
| How to run tests?                     | `flutter test` (13 tests)                          |
| How to lint/analyze?                  | `flutter analyze` (must be clean)                  |

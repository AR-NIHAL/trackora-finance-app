# TrackKora - Finance Tracker

## Overview
A local-only, offline-first personal finance tracker built with Flutter.
Track income, expenses, budgets, and recurring transactions with beautiful charts.

## Tech Stack
| Layer | Technology | Purpose |
|-------|-----------|---------|
| UI | Flutter + Material 3 | Cross-platform (Android, iOS, Web) |
| State | Riverpod (code gen) | State management + dependency injection |
| Storage | Hive CE | Local NoSQL database (community edition, actively maintained) |
| Routing | GoRouter | Declarative routing + deep links |
| Architecture | Clean Architecture | Separation of concerns, testability |
| Models | Freezed | Immutable data classes with code generation |

## Features
1. **Transactions** - Add/Edit/Delete income & expenses with categories, dates, notes
2. **Categories** - 12 predefined + custom categories with icons/colors
3. **Dashboard** - Pie charts (category breakdown), summary cards (income/expenses/balance), recent transactions
4. **Search & Filter** - Text search, type filter, date range, category filter
5. **Budgets** - Monthly spending limits per category with progress bars
6. **Recurring Transactions** - Auto-generate subscriptions, rent, salary entries
7. **Export** - CSV and PDF export with date range selection
8. **Dark/Light Theme** - System-based + manual toggle (persisted in Hive)

## Project Structure
```
lib/
├── core/                          # Shared across all features
│   ├── constants/                 # AppColors, AppStrings, HiveBoxes
│   ├── theme/                     # AppTheme (light + dark)
│   ├── utils/                     # DateUtils, CurrencyUtils
│   ├── router/                    # GoRouter + ScaffoldWithNavBar
│   ├── hive/                      # Hive adapters (generated)
│   └── extensions/
│
├── features/                      # Feature modules
│   ├── transactions/              # Transaction CRUD
│   │   ├── data/                  # TransactionModel, RepositoryImpl
│   │   ├── domain/                # Transaction entity, TransactionType enum, Repository interface
│   │   └── presentation/         # Screens, widgets, providers
│   │
│   ├── categories/                # Category management
│   │   ├── data/                  # CategoryModel, DefaultCategories, RepositoryImpl
│   │   ├── domain/                # Category entity, Repository interface
│   │   └── presentation/         # Screens, providers
│   │
│   ├── dashboard/                 # Home dashboard + charts
│   │   └── presentation/         # DashboardScreen with PieChart + summary cards
│   │
│   ├── budgets/                   # Budget tracking
│   │   ├── data/                  # BudgetModel, RepositoryImpl
│   │   ├── domain/                # Budget entity, Repository interface
│   │   └── presentation/         # Screens, BudgetCard widget, providers
│   │
│   ├── recurring/                 # Recurring transactions
│   │   ├── data/                  # RecurringTransactionModel, RepositoryImpl
│   │   ├── domain/                # RecurringTransaction entity, frequency enum
│   │   └── presentation/         # Screens, providers
│   │
│   ├── search/                    # Search & filter
│   │   └── presentation/         # SearchScreen with filters
│   │
│   ├── export/                    # CSV/PDF export
│   │   ├── data/                  # CsvExporter, PdfExporter
│   │   └── presentation/         # ExportScreen, providers
│   │
│   └── settings/                  # Theme toggle, preferences
│       └── presentation/         # SettingsScreen with theme radio + data links
│
├── app.dart                       # MaterialApp.router, ProviderScope
└── main.dart                      # Hive init, adapter registration, runApp
```

## Key Dependencies
```yaml
dependencies:
  flutter_riverpod: ^2.6.1
  riverpod_annotation: ^2.6.1
  go_router: ^14.8.1
  hive_ce: ^2.19.3
  hive_ce_flutter: ^2.3.4
  freezed_annotation: ^2.4.4
  fl_chart: ^0.70.2
  intl: ^0.20.2
  uuid: ^4.5.1
  csv: ^6.0.0
  share_plus: ^10.1.4

dev_dependencies:
  build_runner: ^2.4.14
  riverpod_generator: ^2.6.3
  hive_ce_generator: ^1.9.2
  freezed: ^2.5.8
  json_serializable: ^6.9.4
```

## Key Decisions
- **Hive CE** (Community Edition) instead of original Hive - actively maintained, freezed support
- **Single `@GenerateAdapters` file** in `lib/core/hive/hive_adapters.dart` for all Hive models
- **No backend** - all data stored locally via Hive
- **Riverpod code gen** - using `@riverpod` annotations where possible
- **Freezed** for immutable entities in domain layer
- **Hive models separate from domain entities** - Clean Architecture pattern

## Routes
| Route | Screen | Description |
|-------|--------|-------------|
| `/dashboard` | DashboardScreen | Home with charts + summary |
| `/transactions` | TransactionsScreen | Transaction list |
| `/budgets` | BudgetsScreen | Monthly budgets |
| `/settings` | SettingsScreen | Theme + data management |
| `/add-transaction` | AddTransactionScreen | Add new transaction |
| `/edit-transaction/:id` | AddTransactionScreen | Edit transaction |
| `/categories` | CategoriesScreen | Manage categories |
| `/search` | SearchScreen | Search + filter |
| `/recurring` | RecurringScreen | Recurring transactions |
| `/add-recurring` | AddRecurringScreen | Add recurring |
| `/export` | ExportScreen | Export data |

## Build Commands
```bash
# Install dependencies
flutter pub get

# Run code generation
dart run build_runner build --delete-conflicting-outputs

# Run app
flutter run

# Analyze
flutter analyze
```

## Progress Log
| Date | Phase | Status |
|------|-------|--------|
| 2026-07-20 | Planning | Complete |
| 2026-07-20 | Phase 1: Foundation | Complete |
| 2026-07-20 | Phase 2: Transactions CRUD | Complete |
| 2026-07-20 | Phase 3: Categories | Complete |
| 2026-07-20 | Phase 4: Dashboard | Complete |
| 2026-07-20 | Phase 5: Search & Filter | Complete |
| 2026-07-20 | Phase 6: Budgets | Complete |
| 2026-07-20 | Phase 7: Recurring | Complete |
| 2026-07-20 | Phase 8: Export | Complete |
| 2026-07-20 | Phase 9: Settings | Complete |
| 2026-07-20 | All phases | **DONE** |

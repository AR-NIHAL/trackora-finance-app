# FinTrack - Personal Finance Tracker

> A Flutter-based personal finance tracking app with transaction management, budget tracking, and analytics.

## Tech Stack

| Technology | Purpose |
|---|---|
| **Flutter** (SDK ^3.10.8) | Cross-platform UI framework |
| **Dart** | Programming language |
| **flutter_riverpod** (2.6.1) | State management |
| **hive** (^2.2.3) + **hive_flutter** (^1.1.0) | Local NoSQL database/persistence |
| **build_runner** (^2.4.13) | Code generation for Hive TypeAdapters |
| **hive_generator** (^2.0.1) | Hive code generation |
| **Material 3** | Design system (Teal color seed) |
| **flutter_test** | Testing framework |

## Project Structure

```
fintrack/
  lib/
    main.dart                               # Entry point - Hive init + ProviderScope
    app/
      app.dart                              # MaterialApp with light/dark themes
      app_initializer.dart                  # Splash screen - loads data before routing
      router/
        app_router.dart                     # Bottom nav routing (5 tabs)
      theme/
        app_theme.dart                      # Light & dark theme definitions
        theme_provider.dart                 # Riverpod provider for theme mode
    core/
      constants/
        app_colors.dart                     # Color constants
        app_sizes.dart                      # Sizing constants
        app_strings.dart                    # String constants
      services/
        local_storage_service.dart          # Hive-based local storage abstraction
    features/
      analytics/
        providers/
          analytics_provider.dart           # Filter, income/expense/balance, category totals
        presentation/
          screens/
            analytics_screen.dart           # Analytics dashboard
          widgets/
            analytics_chart.dart            # Custom bar chart
            analytics_filter_tabs.dart      # All / Monthly / Weekly tabs
            analytics_summary.dart          # Summary cards
      budget/
        data/models/
          budget_model.dart                 # BudgetModel Hive object
          budget_model.g.dart               # Auto-generated adapter
        providers/
          budget_provider.dart              # CRUD + aggregate providers
        presentation/
          screens/
            budget_screen.dart              # Budget overview
          widgets/
            budget_card.dart                # Per-category budget card
            budget_form_dialog.dart         # Add/edit budget dialog
            budget_progress_bar.dart        # Linear progress indicator
      home/
        presentation/
          screens/
            home_screen.dart                # Dashboard
          widgets/
            balance_card.dart               # Gradient balance card
            home_header.dart                # Welcome header
            recent_transaction_list.dart    # Last 5 transactions
            summary_card.dart               # Income/Expense card
            transaction_search_bar.dart     # Search input
      settings/
        presentation/
          screens/
            settings_screen.dart            # Settings
          widgets/
            currency_tile.dart              # Currency display (placeholder)
            settings_section.dart           # Section container
            theme_tile.dart                 # Dark mode toggle
      transactions/
        data/models/
          transaction_model.dart            # TransactionModel Hive object
          transaction_model.g.dart          # Auto-generated adapter
        providers/
          transaction_provider.dart         # CRUD + computed totals
          transaction_state.dart            # State class with getters
          transaction_filter_provider.dart  # Search, type, category filters
        presentation/
          screens/
            add_transaction_screen.dart     # Add transaction
            edit_transaction_screen.dart    # Edit transaction
          widgets/
            amount_field.dart               # Amount input with BDT prefix
            category_dropdown.dart          # Dynamic category dropdown
            transaction_form.dart           # Full form (reused)
            transaction_tile.dart           # List tile with edit/delete
            transaction_type_selector.dart  # Income/Expense toggle
    shared/
      widgets/
        app_scaffold.dart                   # SafeArea + padding wrapper
  test/
    widget_test.dart                        # Default boilerplate test (not adapted)
  docs/
    project-overview.md                     # This file
```

## Routing

Manual bottom navigation bar approach in `app_router.dart`:

| Index | Screen | Icon |
|---|---|---|
| 0 | `HomeScreen` | `home` |
| 1 | `AnalyticsScreen` | `bar_chart` |
| 2 | `AddTransactionScreen` | `add_circle` |
| 3 | `BudgetScreen` | `account_balance_wallet` |
| 4 | `SettingsScreen` | `settings` |

Edit/Delete actions navigate via `Navigator.push(MaterialPageRoute)`.

## State Management (Riverpod)

### Providers

| Provider | Type | Purpose |
|---|---|---|
| `themeModeProvider` | `StateProvider<ThemeMode>` | Light/dark toggle |
| `transactionProvider` | `StateNotifierProvider<TransactionNotifier, TransactionState>` | Transaction CRUD + state |
| `searchQueryProvider` | `StateProvider<String>` | Search input |
| `selectedTypeProvider` | `StateProvider<String>` | Type filter |
| `selectedCategoryProvider` | `StateProvider<String>` | Category filter |
| `filteredTransactionsProvider` | `Provider<List<TransactionModel>>` | Derived filtered list |
| `availableCategoriesProvider` | `Provider<List<String>>` | Dynamic categories |
| `totalIncomeProvider` | `Provider<double>` | Total income |
| `totalExpenseProvider` | `Provider<double>` | Total expense |
| `totalBalanceProvider` | `Provider<double>` | Balance (income - expense) |
| `recentTransactionsProvider` | `Provider<List<TransactionModel>>` | Last 5 transactions |
| `budgetProvider` | `StateNotifierProvider<BudgetNotifier, List<BudgetModel>>` | Budget CRUD |
| `budgetExpenseByCategoryProvider` | `Provider<Map<String, double>>` | Expenses grouped by category |
| `totalBudgetLimitProvider` | `Provider<double>` | Sum of all budget limits |
| `totalBudgetSpentProvider` | `Provider<double>` | Total spent across budgets |
| `totalBudgetRemainingProvider` | `Provider<double>` | Remaining budget |
| `budgetStatusListProvider` | `Provider<List<BudgetStatusItem>>` | Per-category status with progress |
| `analyticsFilterProvider` | `StateProvider<String>` | All/Monthly/Weekly |
| `filteredAnalyticsTransactionsProvider` | `Provider<List<TransactionModel>>` | Filtered for analytics |
| `analyticsIncomeProvider` | `Provider<double>` | Analytics income |
| `analyticsExpenseProvider` | `Provider<double>` | Analytics expense |
| `analyticsBalanceProvider` | `Provider<double>` | Analytics balance |
| `analyticsCategoryTotalsProvider` | `Provider<Map<String, double>>` | Sorted category totals |
| `analyticsTopCategoryProvider` | `Provider<String>` | Highest expense category |
| `analyticsTransactionCountProvider` | `Provider<int>` | Transaction count |
| `localStorageServiceProvider` | `Provider<LocalStorageService>` | Hive service singleton |

## Database Schema (Hive)

### TransactionModel (typeId: 0)

| Field | Type | HiveField |
|---|---|---|
| id | `String` | 0 |
| title | `String` | 1 |
| amount | `double` | 2 |
| type | `String` (income/expense) | 3 |
| category | `String` | 4 |
| date | `DateTime` | 5 |
| note | `String?` | 6 |

### BudgetModel (typeId: 1)

| Field | Type | HiveField |
|---|---|---|
| id | `String` | 0 |
| category | `String` | 1 |
| limitAmount | `double` | 2 |
| createdAt | `DateTime` | 3 |

### Categories

**Income:** Salary, Freelance, Business, Investment, Gift, Other Income

**Expense:** Food, Transport, Bills, Shopping, Entertainment, Health, Education, Other Expense

## Data Flow

```
main.dart
  -> Hive.initFlutter()
  -> Register adapters, open boxes
  -> ProviderScope(child: ExpenseTrackerApp)

ExpenseTrackerApp
  -> watches themeModeProvider
  -> renders MaterialApp with light/dark ThemeData

AppInitializer
  -> initState: loadTransactions() + loadBudgets()
  -> shows CircularProgressIndicator
  -> when ready: AppRouter

AppRouter
  -> Scaffold with NavigationBar (5 tabs)
  -> body switches between screen widgets

Widgets watch providers via ref.watch()
  -> Any change (add/update/delete transaction/budget)
  -> Provider recomputes derived values
  -> UI rebuilds automatically
```

## Features

### 1. Transaction Management
- Full CRUD with Hive persistence
- Income/Expense type toggle
- Dynamic category dropdown based on type
- Amount validation (>0, decimal format)
- Date picker + optional note
- Inline edit (tap tile) and delete (long press + confirm dialog)
- Search across title, category, and notes

### 2. Budget Tracking
- Set spending limits per expense category
- Smart merge: updating a category budget overwrites existing
- Per-card progress bars with exceeded warning (red)
- Overall budget summary (total limit, spent, remaining)
- Delete budget cards

### 3. Analytics Dashboard
- Filter: All time / Monthly / Weekly
- Summary cards: Income, Expense, Balance, Transaction Count
- Top expense category highlight
- Horizontal bar chart showing expense breakdown by category

### 4. Home Dashboard
- Teal gradient balance card (floating)
- Income/Expense summary cards
- Real-time search bar
- Recent 5 transactions with inline edit/delete
- Transaction count

### 5. Settings
- Dark mode toggle (light/dark via Riverpod - **not persisted**)
- Currency display (placeholder - BDT hardcoded)
- App info (v1.0.0)

## Edge Cases Handled

- Empty state: "No transactions found" / "No budgets added yet"
- Budget exceeded: Red progress bar + "Exceeded by ৳X" text
- Amount validation: must be > 0, must be valid number
- Form validation: title required, category required
- Negative balance: displayed correctly
- Empty analytics chart: "No expense data available"

## Known Issues & Missing Features

- **Theme preference not persisted** to Hive (resets on app restart)
- **Currency tile is a placeholder** (BDT hardcoded throughout)
- **No edit for budgets** (only add/delete)
- **No cloud sync** or backup
- **No recurring transactions**
- **No multi-currency support**
- **No authentication**
- **No export/import**
- **Tests are boilerplate** (not adapted to the actual app)
- **No AI features**

## How to Run

```bash
flutter pub get
dart run build_runner build   # Regenerate Hive adapters if needed
flutter run
```

## How to Test

```bash
flutter test
```

Current test coverage is minimal - only the default Flutter counter test exists, which **will fail** since it references widgets not in this app.

## Sibling Projects

Workspace root contains two other Flutter projects:
- **`expense_tracker/`**: Simpler version (Riverpod only, no database)
- **`trackora/`**: More advanced (SQLite, fl_chart, intl, shared_preferences)

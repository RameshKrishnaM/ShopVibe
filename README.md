# ShopVibe - Flutter E-Commerce & Cart Application

[![Flutter](https://img.shields.io/badge/Flutter-3.44.1-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.12.1-0175C2?logo=dart)](https://dart.dev)
[![BLoC](https://img.shields.io/badge/State%20Management-BLoC%20%2F%20Cubit-blueviolet)](https://bloclibrary.dev)
[![Tests](https://img.shields.io/badge/Tests-19%20Passing-brightgreen)](#automated-testing)
[![Architecture](https://img.shields.io/badge/Architecture-Clean%20%2F%20Feature--First-blue)](#architecture)
[![License](https://img.shields.io/badge/License-MIT-green)](LICENSE)

A high-performance, production-ready Flutter e-commerce application developed as part of the **Flutter Developer Practical Assessment**. Built following clean architecture, modern Material 3 design system, and robust state management powered by **BLoC and Cubit**.

---

## 📱 Feature Overview

### 1. Screen 1: Login Screen
* **Email & Password Input**: Sleek fields with custom prefix/suffix icons.
* **Reactive Validation**: The **Sign In button is enabled ONLY when both email and password are valid** (non-empty, RFC-compliant email regex, password $\ge$ 6 characters).
* **Show/Hide Password**: Instant toggle with animated visibility icon.
* **Quick Demo Autofill**: One-tap quick-fill banner for fast evaluation (`alex@example.com` / `password123`).
* **Authentication Flow**: Simulates asynchronous local authentication with realistic latency and error notifications, smoothly navigating to the Product Listing screen upon success.

### 2. Screen 2: Product Listing Screen
* **Curated Catalog**: 8 high-end fashion and lifestyle items with images, category tags, star ratings, descriptions, and formatted pricing.
* **Reusable Product Cards**: Responsive grid (`ProductCard`) with image loading shimmers, offline graceful fallbacks, and category pills.
* **Instant Search & Category Filters**: Real-time keyword search and category pills ('All', 'Jackets', 'Shirts', 'Shoes', 'Accessories') driven by `ProductCubit`.
* **Live Cart Counter**: Real-time badge counter on the App Bar cart icon driven by `CartBloc`.
* **Interactive Feedback**: Floating SnackBar notification with "VIEW CART" action when an item is added.

### 3. Screen 3: Cart Screen
* **Line Items List**: Reusable `CartItemTile` displaying product thumbnail, name, unit price, quantity stepper, and remove button.
* **Quantity Stepper**: Direct increment (+) and decrement (-). Decrementing below 1 cleanly removes the item from the cart.
* **Remove Product**: Dedicated delete button with instant removal.
* **Order Summary Card**: Sticky bottom sheet calculating subtotal, free shipping threshold evaluation, and grand total.
* **Empty Cart State**: Engaging `EmptyStateView` with illustration and "Start Shopping" button when cart has 0 items.
* **State Persistence**: Cart state is globally managed at root and seamlessly preserved across navigation stack pushes and pops.
* **Checkout Simulation**: Interactive celebration modal on order placement.

---

## 🏗️ Architecture & Project Structure

The project follows a **Clean Architecture / Feature-First** separation of concerns:

```
lib/
├── core/
│   ├── constants/
│   │   ├── app_colors.dart         # Cohesive design system & colors
│   │   └── app_constants.dart      # Demo credentials & store constants
│   ├── theme/
│   │   └── app_theme.dart          # Modern Material 3 theme configuration
│   └── utils/
│       ├── currency_formatter.dart # Currency formatting ($XX.XX)
│       └── validators.dart         # Email & password validation rules
├── data/
│   ├── mock/
│   │   └── mock_products.dart      # Static local catalog (8 items)
│   ├── models/
│   │   ├── cart_item_model.dart    # Cart item entity with line subtotal
│   │   ├── product_model.dart      # Product entity (Equatable)
│   │   └── user_model.dart         # Authenticated user entity
│   └── repositories/
│       ├── auth_repository.dart    # Mock authentication repository
│       └── product_repository.dart # Local product query repository
├── logic/
│   ├── auth/
│   │   ├── auth_cubit.dart         # High-level auth lifecycle
│   │   ├── auth_state.dart         # Auth states (Loading, Success, Failure)
│   │   ├── login_form_cubit.dart   # Reactive form validation & visibility
│   │   └── login_form_state.dart   # Form state (email, password, isValid)
│   ├── cart/
│   │   ├── cart_bloc.dart          # Event-driven Cart BLoC
│   │   ├── cart_event.dart         # Add, Remove, Update, Clear events
│   │   └── cart_state.dart         # Immutable cart items & totals
│   └── products/
│       ├── product_cubit.dart      # Catalog loading & instant search/filter
│       └── product_state.dart      # Loaded products & active filter state
├── presentation/
│   ├── navigation/
│   │   └── app_router.dart         # Named routing management
│   ├── screens/
│   │   ├── auth/
│   │   │   └── login_screen.dart   # Login screen
│   │   ├── cart/
│   │   │   └── cart_screen.dart    # Cart screen
│   │   └── products/
│   │       └── product_listing_screen.dart # Product catalog screen
│   └── widgets/
│       ├── cart_badge_icon.dart    # Live cart badge icon
│       ├── cart_item_tile.dart     # Cart item tile with stepper
│       ├── custom_button.dart      # Reusable styled button
│       ├── custom_text_field.dart  # Reusable input field
│       ├── empty_state_view.dart   # Reusable empty state display
│       ├── price_summary_card.dart # Order summary & checkout card
│       └── product_card.dart       # Reusable product catalog card
└── main.dart                       # App entry point with MultiBlocProvider
```

---

## ⚡ State Management Decisions (BLoC vs. Cubit)

In this project, both **BLoC** and **Cubit** are strategically utilized to demonstrate mastery of both paradigms:

| Component | Pattern | Rationale |
|:---|:---:|:---|
| **Cart** | **BLoC** (`CartBloc`) | Shopping cart actions (`AddToCart`, `RemoveFromCart`, `UpdateQuantity`, `ClearCart`) are **event-driven**. BLoC provides a clear audit trail of events, supports advanced event debounce/transforms, and scales cleanly for analytics and multi-step mutations. |
| **Auth** | **Cubit** (`AuthCubit`) | Authentication states (`Initial`, `Loading`, `Authenticated`, `Failure`) transition predictably based on direct actions (`login()`, `logout()`). Cubit eliminates unnecessary boilerplate while maintaining complete immutability. |
| **Login Form** | **Cubit** (`LoginFormCubit`) | Real-time keystroke validation requires synchronous state emissions on every character entered. Cubit is lightweight and ideal for reactive UI form enabling. |
| **Products** | **Cubit** (`ProductCubit`) | Catalog loading, category chip selections, and search keyword filtering map cleanly to state emissions with minimal overhead. |

---

## 🧪 Automated Testing

The codebase includes comprehensive unit tests and widget tests with **100% pass rate**:

* **`cart_bloc_test.dart`**:
  * Initial state verification.
  * Adding new products vs. updating quantities of existing items.
  * Price subtotal and grand total calculations.
  * Stepper increment / decrement logic and automatic removal at 0.
  * Clearing the entire cart.
* **`login_form_cubit_test.dart`**:
  * Email format validation tests.
  * Password length requirement tests ($\ge$ 6 characters).
  * Enabling the Login button **only** when both fields are valid (`isValid == true`).
  * Password visibility toggle.
  * Demo credentials quick-fill.
* **`product_cubit_test.dart`**:
  * Loading $\ge$ 5 products from repository.
  * Filtering products by category.
  * Instant search query filtering.
* **`widget_test.dart`**:
  * End-to-end Login screen rendering and interactive validation.

### Running Tests:
```bash
flutter test
```
Result:
```text
00:04 +19: All tests passed!
```

### Static Analysis:
```bash
flutter analyze
```
Result:
```text
No issues found! (ran in 4.1s)
```

---

## 🚀 Getting Started & Setup

### Prerequisites
* Flutter SDK (3.24+ recommended, tested on Flutter 3.44.1)
* Dart SDK (3.5+)
* Any device/emulator: Windows Desktop, Android, iOS, Chrome, or Edge

### Installation
1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd shopvibe
   ```

2. Fetch dependencies:
   ```bash
   flutter pub get
   ```

3. Run the application:
   ```bash
   # Run on default connected device (Desktop / Chrome / Mobile)
   flutter run

   # Or specify target:
   flutter run -d chrome
   flutter run -d windows
   ```

---

## 🔑 Demo Credentials

To evaluate the app in 1 second, you can either:
1. Tap the **"Tap to autofill demo credentials"** button on the Login screen, or
2. Manually enter:
   * **Email**: `alex@example.com`
   * **Password**: `password123`

*(Note: Any RFC-compliant email address and password of 6+ characters will also successfully authenticate).*

---

## 📹 Demo Video Recording Checklist

For the assessment submission video recording, follow this 60-second walkthrough:
1. **Login Screen**:
   * Show disabled Sign In button initially.
   * Type invalid email (error shows).
   * Tap "Tap to autofill demo credentials" (button turns active).
   * Tap the eye icon to show/hide the password.
   * Tap "Sign In" (loading spinner appears, navigates to Products).
2. **Product Listing Screen**:
   * Scroll through the 8 curated clothing items.
   * Filter by category (e.g. tap "Jackets", "Shoes").
   * Type in search bar (e.g. "Sneakers" or "Denim").
   * Tap "Add" on 2-3 different products.
   * Observe the SnackBar confirmation and the live cart badge count updating in the AppBar.
3. **Cart Screen**:
   * Tap the Cart icon in the AppBar.
   * Increase quantity with (+).
   * Decrease quantity with (-).
   * Remove an item with the trash icon.
   * Observe live subtotal, free shipping badge, and total amount recalculations.
   * Tap "Checkout" and view confirmation dialog.
   * Tap "Back to Shopping" and observe empty cart handling.

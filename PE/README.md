# Shop App â€” Product Management & Shopping Cart (Flutter)

Cross-platform Flutter app (Android / iOS / Web / Windows) that talks to a
mock REST API (JSON Server). Covers registration, login with Remember Me,
product CRUD, search, sort, shopping cart, checkout and revenue statistics.

## Tech stack
- Flutter + Material 3
- provider â€” state management
- go_router â€” navigation / routing
- http â€” REST client
- shared_preferences â€” Remember Me / session
- crypto â€” SHA-256 password hashing
- intl â€” currency & date formatting
- JSON Server â€” mock REST API backend

## Project layout
```
lib/
  main.dart                app bootstrap + providers
  app_router.dart          go_router config + auth redirect
  data/                    api_config + REST repositories
  models/                  user, product, cart_item, order
  providers/               auth, product, cart, order (ChangeNotifier)
  screens/                 login, register, product list/detail/form, cart, revenue
  utils/                   crypto + formatters
mock_api/
  db.json                  seed data (users, products, orders)
  start-api.ps1            helper to launch JSON Server
```

## 1) Run the mock API (required)
```powershell
cd mock_api
npx json-server db.json --port 3001
```
Server runs at http://localhost:3001 with `/users`, `/products`, `/orders`.

Note: port 3001 is used because port 3000 is taken by a Windows service on
this machine. Change it in both `mock_api/start-api.ps1` and
`lib/data/api_config.dart` if needed.

## 2) Run the app
```powershell
flutter pub get
flutter run            # pick a device (Chrome / Windows / emulator)
flutter run -d chrome  # web
```

The base URL auto-switches per platform (see `lib/data/api_config.dart`):
- Android emulator: `http://10.0.2.2:3001`
- Web / iOS sim / Windows: `http://localhost:3001`

## Accounts & roles
The app has two roles:
- `admin` — can add / edit / delete products and view revenue statistics.
- `customer` — can browse, search, sort, add to cart and checkout only.

Demo admin account:
- Email: `admin@shop.com`
- Password: `123456`

New accounts registered from the login screen are always `customer`.
Product management buttons (Add / Edit / Delete) and the Revenue screen are
hidden for customers, and the admin-only routes are also guarded in the router.

## Features
- Registration with email-format + confirm-password validation
- Login validated against stored users; Remember Me via SharedPreferences
- Product list with ListView.builder, images, price
- Product CRUD (add / detail / edit / delete)
- Real-time search by name
- Sort by price ascending / descending
- Cart: add from list or detail, change quantity, remove, live total
- Checkout: confirmation dialog, records an order
- Revenue statistics: total revenue, order count, items sold, filter by
  All / Day / Month / Year
- Feedback via SnackBar, AlertDialog and Dialog

## Tests
```powershell
flutter test      # unit tests for hashing, cart totals, order totals
flutter analyze   # static analysis (clean)
```
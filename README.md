# 🩸 RaktaSetu — Smart Blood Bank & Donor Locator

**Phase 1 + Phase 2** (Flutter + Dart, mock data) · Tagline: *"Find Blood Fast. Save Lives."*

## Features (Phase 1 — find blood)

| Module | Where |
|---|---|
| Splash (logo, name, tagline) | `lib/screens/splash/splash_screen.dart` |
| Auth: register / login / logout / forgot password / profile | `lib/screens/auth/`, `lib/screens/profile/`, `lib/services/auth_service.dart` |
| Home dashboard (name + blood group, emergencies, nearby, notifications) | `lib/screens/home/home_screen.dart` |
| Find Blood (8 groups, area + facility filters, Available/Limited/Unavailable) | `lib/screens/find_blood/find_blood_screen.dart` |
| Top Hospitals (search, area, verified filter, detail + stock) | `lib/screens/hospitals/` |
| Blood Bank Centers (search, filters, detail + stock) | `lib/screens/blood_banks/` |
| Area-wise requirements (emergency level filter) | `lib/screens/requirements/requirements_screen.dart` |
| Notifications (8 categories with filter chips) | `lib/screens/notifications/notifications_screen.dart` |
| Basic Safety (eligibility, pre/post precautions, screening) | `lib/screens/safety/safety_screen.dart` |

## Features (Phase 2 — donate)

| Module | Where |
|---|---|
| Donor profile (age, eligibility status, donation count) | `lib/models/donor.dart`, `lib/services/donor_service.dart` |
| Slot booking (facility → date → time slot → confirm/cancel/reschedule) | `lib/screens/donate/book_slot_screen.dart`, `lib/screens/donate/my_bookings_screen.dart` |
| Donation history (dates, facility, blood group, status) | `lib/screens/donate/donation_history_screen.dart` |
| Monthly donation camps (list, detail, register) | `lib/screens/camps/camps_screen.dart`, `lib/data/camps_data.dart` |
| Donor certificate (auto-generated after completed donation, shareable text) | `lib/screens/donate/certificates_screen.dart`, `lib/models/donor_certificate.dart` |
| Donor notifications (slot confirmation, reminders, camp notices, updates) | `lib/services/donor_service.dart`, `lib/data/donor_seed_data.dart` |
| Donor dashboard (next appointment, history, upcoming camps, certificates) | `lib/screens/donate/donate_screen.dart` |

Bottom navigation: **Home | Find Blood | Donate | Camps | Profile**
(Hospitals & Blood Banks remain reachable from Home → "See all".)

Mock data: 12 hospitals, 12 blood banks, 12 requirements, 12 notifications,
8 camps, demo donor history/bookings/certificates — in `lib/data/`.

## Project structure

```
lib/
├── main.dart            # entry point
├── app.dart             # MaterialApp + routes
├── core/app_theme.dart  # colors + Material 3 theme
├── models/              # plain Dart models (users, facilities,
│                        #   bookings, camps, certificates, …)
├── data/                # mock datasets (Phase 1 + Phase 2)
├── services/            # AuthService, BloodService, DonorService
│                        #   (singletons — swap internals for APIs later)
├── widgets/             # reusable UI components
└── screens/             # splash, auth, main, home, find_blood,
                         #   hospitals, blood_banks, requirements,
                         #   notifications, safety, profile,
                         #   donate (dashboard/booking/history/certificates),
                         #   camps
```

## Run the app

**1. Install Flutter** (Windows): download the SDK from
https://docs.flutter.dev/get-started/install/windows, extract to `C:\flutter`,
then add `C:\flutter\bin` to your PATH.

**2. Verify the toolchain:**

```bash
flutter doctor
```

**3. Get packages and run:**

```bash
flutter pub get
flutter run
```

Run on Windows desktop, an Android emulator, a connected phone, or Chrome
(`flutter run -d chrome`).

**Demo login:** `demo@raktasetu.in` / `demo123` — the demo donor comes pre-seeded
with donation history, certificates, an upcoming booking and donor notifications.
New accounts can register too (stored in memory; add your age on the Register
form to get an eligibility status).

## Phase 6 readiness (backend)

All data flows through `AuthService`, `BloodService` and `DonorService`
singletons. To connect a real backend, replace the internals of these classes
with API/database calls — no screen or widget code needs to change. Models
already have `toMap()`/`fromMap()` for serialization.

Out of scope for Phase 1–2 (per spec): KYC, Aadhaar, police monitoring,
coupons, doctor consultancy, payments, admin panel.

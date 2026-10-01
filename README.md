# 🩸 RaktaSetu — Smart Blood Bank & Donor Locator

**Phase 1 + 2 + 3** (Flutter + Dart, mock data) · Tagline: *"Find Blood Fast. Save Lives."*

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

## Features (Phase 3 — hospitals, doctors & admin)

| Module | Where |
|---|---|
| Roles (donor / hospital admin / blood bank admin) + managed facility | `lib/models/user.dart`, demo logins below |
| Doctors tab (search, specialization filters, profiles, fees, status) | `lib/screens/doctors/`, `lib/data/doctors_data.dart` |
| Consultation booking (date picker, 30-min slots, consulting-day rules, cancel, history) | `lib/screens/doctors/doctor_profile_screen.dart`, `lib/screens/doctors/my_appointments_sheet.dart` |
| Hospital-wise doctor listing | `lib/screens/hospitals/hospital_detail_screen.dart` |
| Hospital Admin dashboard (info, doctors, inventory, appointments, camps, requests) | `lib/screens/admin/hospital_admin_screen.dart` |
| Blood Bank Admin dashboard (inventory updates, slots, donors, records, requests) | `lib/screens/admin/blood_bank_admin_screen.dart` |
| Blood requests (raise / fulfil with auto stock deduction / reject) | `lib/models/blood_request.dart`, `lib/services/admin_service.dart` |
| Blood inventory updates (per-group units, live status recompute) | `lib/services/admin_service.dart` |

Bottom navigation: **Home | Find Blood | Hospitals | Doctors | Blood Banks | Profile**
(Donate dashboard, Camps and admin dashboards are reachable from Home.)

Mock data: 12 hospitals, 12 blood banks, 12 requirements, 12 notifications,
8 camps, 18 doctors, demo donor history/bookings/certificates — in `lib/data/`.

**Demo logins** (password `demo123` for all):

| Role | Email |
|---|---|
| 👤 Donor (pre-seeded history, certificates, booking) | `demo@raktasetu.in` |
| 🏥 Hospital Admin (City Care Multispeciality, h01) | `hospital@raktasetu.in` |
| 🩸 Blood Bank Admin (City Care Blood Centre, bb01) | `bloodbank@raktasetu.in` |

New accounts can also pick a role + facility on the Register form.

## Project structure

```
lib/
├── main.dart            # entry point
├── app.dart             # MaterialApp + routes
├── core/app_theme.dart  # colors + Material 3 theme
├── models/              # plain Dart models (users, facilities,
│                        #   bookings, camps, doctors, appointments,
│                        #   certificates, blood requests, …)
├── data/                # mock datasets (Phases 1–3)
├── services/            # AuthService, BloodService, DonorService,
│                        #   DoctorService, AdminService (singletons —
│                        #   swap internals for APIs later)
├── widgets/             # reusable UI components
└── screens/             # splash, auth, main, home, find_blood,
                         #   hospitals, blood_banks, doctors, requirements,
                         #   notifications, safety, profile,
                         #   donate (dashboard/booking/history/certificates),
                         #   camps, admin (hospital & blood bank dashboards)
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

The demo donor comes pre-seeded with donation history, certificates, an
upcoming booking and donor notifications. New accounts can register too
(stored in memory; add your age on the Register form to get an eligibility
status, and pick Donor / Hospital / Blood bank as the account type).

## Phase 6 readiness (backend)

All data flows through `AuthService`, `BloodService` and `DonorService`
singletons. To connect a real backend, replace the internals of these classes
with API/database calls — no screen or widget code needs to change. Models
already have `toMap()`/`fromMap()` for serialization.

Out of scope for Phase 1–2 (per spec): KYC, Aadhaar, police monitoring,
coupons, doctor consultancy, payments, admin panel.

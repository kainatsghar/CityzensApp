# Cityzens — School Management System

[![Flutter](https://img.shields.io/badge/Flutter-3.8.1-02569B?logo=flutter&logoColor=white)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.8.1-0175C2?logo=dart&logoColor=white)](https://dart.dev/)
[![Version](https://img.shields.io/badge/version-2.0.0%2B89-10B981)](https://github.com/tcsho/CityzensApp)
[![Firebase](https://img.shields.io/badge/Firebase-Enabled-FFCA28?logo=firebase&logoColor=white)](https://firebase.google.com/)

> Tri-role school management app for **The City School**, built with Flutter and integrated with the AIMS+ ERP REST API.

**Package:** `tcs_app` · **Version:** `2.0.0+89`

---

## Documentation (source of truth)

Full architecture, flows, API catalog, Firebase, handover, and audit live in the Obsidian vault:

**→ Open [`docs/Home.md`](docs/Home.md)**

| Start here | Link |
|---|---|
| Master architecture diagram | [docs/Home.md](docs/Home.md) |
| Vendor handover | [docs/Handover/Vendor Guide.md](docs/Handover/Vendor%20Guide.md) |
| Local setup | [docs/Development/Setup.md](docs/Development/Setup.md) |
| API endpoints | [docs/API/Index.md](docs/API/Index.md) |
| Known issues | [docs/Audit/Known Issues.md](docs/Audit/Known%20Issues.md) |

---

## Quick start

```bash
git clone https://github.com/tcsho/CityzensApp.git
cd CityzensApp
make get
make generate
make pod-install   # iOS
flutter run
```

See [docs/Development/Makefile.md](docs/Development/Makefile.md) for all targets.

### Environments

| Env | Host | How to select |
|---|---|---|
| **Test** (default) | `https://testcityzenapi.csn.edu.pk` | `AppConstants.baseUrl = apiTestBaseURL` |
| Live | `https://cityzenapi.csn.edu.pk` | Switch constant in `lib/utils/app_constants.dart` |

> There are **no** Android/iOS product flavors. `CITYZENS_ENV` dart-define is unused in Dart. Firebase Remote Config `apiBaseUrl` code exists but init is currently disabled.

---

## Architecture (summary)

Provider-based MVVM: **Screens → Providers → Services/Repositories → ApiBaseHelper (`http`) → AIMS+ API**.

```
Screens / Components / Custom Widgets
              ↕
     ChangeNotifier Providers (×30)
              ↕
   Static Services · 5 Repositories
              ↕
        ApiBaseHelper + Models
              ↕
 SharedPreferences / LocalCache / SecureStorage
```

Roles: **Student** · **Teacher** · **Parent** (parent shares student dashboard with multi-child).

Full diagram: [docs/Diagrams/Master Architecture.md](docs/Diagrams/Master%20Architecture.md)

---

## Build & release

```bash
make apk          # Android release APK
make appbundle    # Play Store bundle
```

Signing, iOS pods, versioning, and checklist: [docs/Deployment/Index.md](docs/Deployment/Index.md)

---

## Firebase

Project: `thecityschoolapp` · App ID: `com.tcs.tcsapp`

| Product | Status |
|---|---|
| Messaging | Active |
| Crashlytics | Active |
| Analytics | Active |
| Firestore | Active (`newFeatures`) |
| Remote Config | Code present; **init disabled** |
| Auth / App Distribution | Not used |

Details: [docs/Firebase/Index.md](docs/Firebase/Index.md)

---

## Support

For vendor onboarding, troubleshooting, and ADRs, use the vault — start at [docs/Handover/Index.md](docs/Handover/Index.md).

**Last updated:** 2026-08-04 · **Version:** 2.0.0+89

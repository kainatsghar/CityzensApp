# Architecture Overview

## High-Level Architecture

Cityzens follows a **Provider-based MVVM** architecture:

```
Screens → Components → Custom Widgets
    ↕           ↕
Providers (ChangeNotifier)
    ↕
Services (Static API calls)
    ↕
Models (JSON ↔ Dart)
    ↕
ApiBaseHelper (HTTP Client)
    ↕
SharedPreferences (Local Persistence)
```

## Data Flow

```mermaid
graph LR
    UI["Screen / Component"] -->|reads| P["Provider"]
    UI -->|calls method| P
    P -->|calls| S["Service"]
    S -->|HTTP via| A["ApiBaseHelper"]
    A -->|response| S
    S -->|parsed model| P
    P -->|notifyListeners()| UI
    P -->|caches| SP["SharedPreferences"]
```

## Layer Responsibilities

### Screens (`lib/screens/`)
- StatefulWidgets that represent full pages
- Own the `FutureBuilder` for initial data loading
- Delegate all state to their Provider
- Handle lifecycle (`initState`, `dispose`)

### Components (`lib/components/`)
- Stateless compositions of custom widgets
- Consume providers via `Consumer<T>`
- Represent a logical section of a screen (e.g., attendance calendar, fee card)

### Custom Widgets (`lib/custom_widgets/`)
- Pure, reusable UI primitives with no business logic
- Examples: `CustomAppBar`, `CustomTextFormField`, `CustomAppButton`, `GlassmorphicCard`
- Form the design system foundation

### Providers (`lib/provider/`)
- Extend `ChangeNotifier`
- Hold all mutable state
- Contain business logic and data transformation
- Call services and update UI via `notifyListeners()`
- Registered globally in `app_providers.dart` (30 providers)

### Services (`lib/services/`)
- Static classes with static methods
- Pure API call wrappers — no state, no UI logic
- Parse JSON responses into typed Models
- Throw typed exceptions on failure

### Models (`lib/model/`)
- Plain Dart classes with `fromJson()` factory and `toJson()` method
- Some use `freezed` / `json_serializable` for code generation
- Represent API request/response schemas

### Network (`lib/network/`)
- `ApiBaseHelper`: Centralized HTTP client with GET/POST/PUT/PATCH/DELETE
- `AppExceptions`: Typed exceptions (FetchData, BadRequest, InvalidInput, UnAuthorized)
- Handles: SocketException, FormatException, TimeoutException

## Navigation Architecture

```mermaid
graph TD
    NG["RouteGenerator.generateRoute()"] -->|switch on name| R["60+ named routes"]
    R --> S["Screen Widget"]
    AN["AppNavigation"] -->|navigateTo()| NG
    AN -->|pushReplacementTo()| NG
    AN -->|pushAndKillAll()| NG
    AN -->|goBack()| NAV["Navigator"]
```

- All routes are string constants in `AppNavRoutes`
- `RouteGenerator` uses a `switch` statement mapping route names → Screen widgets
- Transitions: `FadeTransition` with 300ms duration
- Screen arguments passed via `settings.arguments`

## Related Pages

- [[Provider Map]]
- [[API/Endpoint Reference|Endpoint Reference]]
- [[Design System/Index|Design System]]

# Personal Notes

This section is for your personal notes, observations, and reminders.

## Quick Notes

- 

## Meeting Notes

- 

## Ideas & Improvements

- 

## Technical Debt / Known Issues

- `ApiBaseHelper.httpPostRequest()` builds auth headers but doesn't actually send them (uses `AppConstants.appHeaders` instead)
- Some providers access `AppNavigation.currentContext!` in constructor body — tight coupling
- `LoginResponse.toJson()` doesn't include all fields (e.g., `isSuccessful`, `message`)
- A-Level grade detection uses hardcoded `['19', '20']` — should be configurable
- `parentDashboardRoute` and `studentDashboardRoute` point to the same route string `/studentDashboard`

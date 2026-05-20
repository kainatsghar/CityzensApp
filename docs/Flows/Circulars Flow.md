# Circulars Flow

## Overview

Teachers create and manage school circulars/announcements for specific class/sections. Students receive circulars through the notification system. Circulars follow the same CRUD pattern as Homework and Assignments.

## Teacher Flow

```mermaid
graph TD
    A["Teacher Dashboard"] --> B["TeacherAcademicHubScreen"]
    B --> C["Select 'Circulars' tab"]
    C --> D["View existing circulars"]
    
    D -->|Tap FAB| E["AddCircularScreen"]
    D -->|Tap circular| F["View details"]
    F -->|Edit| G["AddCircularScreen<br/>(edit mode)"]
    F -->|Delete| H["Confirm → Delete API"]
    
    E --> I["Select section"]
    I --> J["Select subject"]
    J --> K["Enter title + description"]
    K --> L["Optional: attach file"]
    L --> M["Submit"]
    M -->|Success| N["Reload list → goBack()"]
```

## Student Flow

```mermaid
graph TD
    A["Dashboard / Drawer"] --> B["Tap 'Notifications'"]
    B --> C["NotificationScreen"]
    C --> D["NotificationProvider.loadNotifications()"]
    D --> E["List of circulars"]
    E --> F["View circular details"]
```

## Key Files

| File | Purpose |
|---|---|
| `provider/Circular/circular_provider.dart` | Circular CRUD state |
| `provider/Notification/notification_provider.dart` | Student notification list |
| `screens/Teacher/TeacherCircularScreen/` | Teacher circular list |
| `screens/Teacher/AddCircularScreen/` | Create/edit circular |
| `screens/Student/Notifications/` | Student notification view |

## Related Pages

- [[Teacher Flow]]
- [[Student Flow]]
- [[Homework and Classwork Flow]]

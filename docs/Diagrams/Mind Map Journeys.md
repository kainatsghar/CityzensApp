---
title: Mind Map Journeys
description: Role-based journey mind map rooted at AuthWrapper.
tags: [cityzens, diagrams, mindmap, flows]
created: 2026-08-04
updated: 2026-08-04
owner: Cityzens Engineering
status: verified
---

# Mind Map Journeys

> Back to [[Home]] · [[Diagrams/Index|Diagrams]] · [[Flows/Index|Flows]]

```mermaid
mindmap
  root((AuthWrapper Guard))
    Unauthenticated
      LoginScreen
        Registration OTP
        Forgot Password OTP
        Biometric saved accounts
    Student
      StudentDashboard
        Attendance Standard or ALevel
        Academic Hub Diary Classwork Circulars
        Term Results PDF
        Class Tests
        Fees and Library
        Notifications
    Teacher
      TeacherDashboard
        Mark Attendance
        Mark Unidentified
        Academic Hub CRUD
        Class Test Entry
        Timetable 9x5
        Eye on Your Child
        School Events Surveys
    Parent
      StudentDashboard MultiChild
        Profile edit
        Eye on Your Child view
        Complaint and Query
        Appointments
        Withdrawal
        Challan WebView Pay
```

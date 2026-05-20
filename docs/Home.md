# Cityzens App Documentation

Welcome to the **Cityzens App** Obsidian vault. This is your central documentation hub for the entire project.

## Vault Structure

| Folder | Purpose |
|---|---|
| **[[Architecture/Index\|Architecture]]** | System design, data flow, provider architecture |
| **[[Flows/Index\|Flows]]** | User journey documentation for each role and feature |
| **[[API/Index\|API]]** | API endpoint reference, request/response schemas |
| **[[Design System/Index\|Design System]]** | Colors, widgets, component library reference |
| **[[Features/Index\|Features]]** | Per-feature documentation and status |
| **[[Notes/Index\|Notes]]** | Personal notes, meeting notes, observations |
| **[[Credentials/Index\|Credentials]]** | 🔒 Secure credentials and environment info |

## Quick Links

### Role Flows
- [[Flows/Authentication Flow|Authentication Flow]] — Login, Registration, Forgot Password
- [[Flows/Teacher Flow|Teacher Flow]] — Dashboard, content creation
- [[Flows/Student Flow|Student Flow]] — Viewing academic data
- [[Flows/Parent Flow|Parent Flow]] — Multi-child, complaints

### Feature Flows
- [[Flows/Mark Attendance Flow|Mark Attendance]] — Teacher attendance marking
- [[Flows/Student Attendance Flow|Student Attendance]] — Calendar, A-Level subjects
- [[Flows/Homework and Classwork Flow|Homework & Classwork]] — Diary, assignments CRUD
- [[Flows/Circulars Flow|Circulars]] — Announcements
- [[Flows/Class Test Results Flow|Class Test Results]] — Test marks entry/view
- [[Flows/Term Results Flow|Term Results]] — AIMS+ ERP results
- [[Flows/Timetable Flow|Timetable]] — 9×5 grid management
- [[Flows/Eye on Your Child Flow|Eye on Your Child]] — Activity updates
- [[Flows/Fee and Payment Flow|Fee & Payment]] — Challans, WebView payment
- [[Flows/Complaint and Query Flow|Complaint & Query]] — Categorized complaints

### Architecture
- [[Architecture/Provider Map|Provider Map]] — All 30 providers
- [[API/Index|Endpoint Reference]] — API docs
- [[Design System/Index|Design System]] — Colors, widgets, animations

## Project Metadata

| Key | Value |
|---|---|
| **Package Name** | `tcs_app` |
| **Version** | `1.13.3+88` |
| **Flutter SDK** | `^3.8.1` |
| **State Management** | Provider (ChangeNotifier) |
| **Backend** | AIMS+ ERP REST API |
| **Firebase Project** | `thecityschoolapp` |
| **Environments** | Test: `testcityzenapi.csn.edu.pk` / Live: `cityzenapi.csn.edu.pk` |

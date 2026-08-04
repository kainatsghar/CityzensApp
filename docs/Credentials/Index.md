---
title: Credentials
description: How Cityzens stores secrets — never in git; use gitignored secrets.md.
tags: [cityzens, credentials, security]
created: 2026-08-04
updated: 2026-08-04
owner: Cityzens Engineering
status: verified
---

# Credentials

> Back to [[Home]] · Security hygiene: [[Audit/Known Issues|Known Issues]]

> [!WARNING]
> **Never store secrets in git** (API keys, passwords, `.p8` private keys, keystore passwords, service-account JSON, tokens).
> The `secrets.md` file in this folder is **gitignored** (`docs/Credentials/secrets.md`) and must never be force-added or committed.
> Do not paste secret file contents into Obsidian notes, ADRs, or chat logs.

## Files

| File | Purpose | Git Status |
|---|---|---|
| `secrets.md` | All credentials, API keys, test users, key paths/IDs | 🔒 **Gitignored** |

## What belongs in `secrets.md`

Store **values and private material** only in `secrets.md` (or a team password manager). In the vault, document *where* something lives, not the secret itself.

| Category | Examples |
|---|---|
| Test users | Student / Teacher / Parent usernames & passwords for Test API |
| API | Any non-public tokens, basic-auth, or partner keys |
| Firebase | Service account JSON paths, project IDs already public vs private keys |
| Apple | AuthKey **ID**, Team ID, Key ID — **not** `.p8` file contents; prefer keys outside the repo |
| Google / iOS Firebase plists | Note which plist is canonical (`ios/Runner/…`); do not duplicate secrets into markdown |
| Store accounts | App Store / Play Console logins or shared vault links |
| Android signing | Keystore path, alias, passwords |
| Environment | Live vs Test URLs are in `AppConstants` (not secret); any private staging hosts go here |

## Repo hygiene reminders

- Root `AuthKey_J49ACV752S.p8` is a **tracked risk** — rotate if exposed; remove from VCS; reference only by path/ID in `secrets.md` — [[Audit/Known Issues|Known Issues]]
- Prefer CI secrets / local untracked files over committing `GoogleService-Info.plist` duplicates if policy requires

## Related

- [[Handover/Index|Handover]] (when present)
- [[Firebase/Index|Firebase]]

---
name: anki
description: Use when accessing Anki flashcards.
---

Access Anki through the AnkiConnect plugin at `localhost:8765`. If it does not respond:

1. If Anki running: AnkiConnect is broken; tell the user.
2. Else if Anki installed: launch it detached so it outlives the session, e.g. `systemd-run --user --unit=anki flatpak run net.ankiweb.Anki`.
3. Else if Anki not installed: stop and tell the user.

# Technology Stack: FitQuest

## Frontend Language & Framework
- **Dart & Flutter:** Chosen as the primary frontend framework. It allows for a single codebase across Android and iOS while providing the high-performance graphics engine required for FitQuest's smooth, gamified UI transitions and micro-animations.

## State Management
- **Riverpod:** A modern, compile-safe state management solution. It will effectively manage reactive data states, such as updating the XP bar in real-time as PASSOS are collected.

## Local Database / Storage
- **Hive (NoSQL):** An ultra-fast, lightweight local NoSQL database. It allows FitQuest to save user progress, logs, character data, and Heróis locally without consuming significant system resources.

## External APIs & Device Sensors
- **HealthKit / Health Connect:** Used for direct, simple connection to the device's native health sensors to collect raw effort data (like step counts) and translate them into in-game progress.
- **Geolocator & Google Places API:** Used to track GPS location and validate real-world environments (like gyms) to interpret them as new adventure arenas or "Masmorras".

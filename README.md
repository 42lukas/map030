# 030map

030map is a native iOS application for reporting and viewing public transport events in Berlin in real time.

Instead of reporting incidents based on GPS coordinates alone, reports are linked directly to **public transport stations and lines** (S-Bahn, U-Bahn and Tram). This results in significantly more precise and useful information for commuters.

The project is built with a strong focus on clean architecture, maintainability and native Apple technologies.

---

# Project Status

Current Phase:

🟡 MVP Development

Implemented:

- Native MapKit integration
- User location
- Report creation
- Station search
- Nearby station suggestions
- Local GTFS dataset
- Repository Pattern
- DTO Mapping
- MVVM architecture
- Reusable UI components

Planned:

- UI polish
- Supabase backend
- PostgreSQL
- Realtime reports
- Voting
- Moderation
- Automatic report expiration

---

# Tech Stack

## Platform

- iOS
- Swift
- SwiftUI
- MapKit

## Architecture

- MVVM
- Repository Pattern
- DTO Layer
- Dependency Injection
- Feature-based project structure

## Data

- GTFS Transit Data
- JSON Resources
- Codable
- Local Repository

Planned

- Supabase
- PostgreSQL
- Realtime Database

---

# Project Structure

```
App/
Core/
Data/
Domain/
Features/
Shared/
Resources/
```

## App

Application entry point.

Contains:

- App lifecycle
- AppContainer
- Dependency injection

---

## Core

Infrastructure.

Examples:

- LocationManager

---

## Data

Responsible for external data sources.

Contains:

- DTOs
- Repositories
- Mappers
- JSON loading

The Data layer never contains UI logic.

---

## Domain

Pure business models.

Examples:

- Report
- TransitStation
- TransitLine

The Domain layer is completely independent of SwiftUI.

---

## Features

Every user-facing feature is isolated.

Current features:

- Map
- Report Creation

Each feature owns its:

- Views
- ViewModels
- Components
- Feature-specific models

---

## Shared

Reusable code.

Examples:

- Design System
- Components
- Extensions
- Utilities

Everything placed here should be usable by multiple features.

---

# Architecture

The application follows MVVM.

```
View
    ↓
ViewModel
    ↓
Repository
    ↓
DTO
    ↓
JSON / Backend
```

Views contain no business logic.

ViewModels own application state.

Repositories abstract data sources.

DTOs isolate external data formats from domain models.

Domain models are never coupled to the persistence layer.

---

# Design Principles

This project intentionally prioritizes long-term maintainability over rapid implementation.

Guidelines:

- Small reusable views
- Single Responsibility Principle
- Composition over inheritance
- Feature isolation
- Minimal code duplication
- Native SwiftUI APIs
- Explicit state management
- Strong typing
- No business logic inside Views

---

# Coding Style

General rules:

- Descriptive naming
- One responsibility per type
- Private where possible
- MARK sections
- Small functions
- Minimal nesting
- Consistent formatting

Business logic belongs inside ViewModels.

Views should primarily describe UI.

---

# Transit Data

The application uses GTFS data.

Only the following transport modes are currently imported:

- S-Bahn
- U-Bahn
- Tram

Bus and regional rail are intentionally excluded during the MVP phase.

The GTFS importer is maintained separately and is **not part of this repository**.

---

# Development Roadmap

## Sprint 1

- Initial architecture
- MVVM
- Map integration
- Dependency Injection
- Local reports

## Sprint 2

- Station search
- Station list
- Nearby stations
- Search improvements

## Sprint 3

- Design System
- UI polish
- Custom markers
- Improved map interaction
- Better report presentation

## Sprint 4

- Supabase
- PostgreSQL
- Realtime synchronization

## Sprint 5

- Report expiration
- Community voting
- Moderation

---

# Philosophy

030map aims to provide a fast, lightweight and privacy-friendly way to share public transport information.

Instead of tracking continuous user movement, reports are attached to stations and optionally to specific lines, creating information that remains relevant for everyone using the same public transport infrastructure.

The project intentionally embraces native iOS development principles and avoids unnecessary third-party dependencies whenever Apple's frameworks provide a sufficient solution.


---

~Lukas

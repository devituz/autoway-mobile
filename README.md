# AutoWay Flutter Project

This project follows **Feature-first Clean Architecture**.

## Architecture Overview

The project is divided into two main layers: `core` and `features`.

### 1. Core (`lib/core/`)
Contains shared logic, constants, themes, and cross-cutting concerns.
- `theme/`: App colors, typography, and theme data.
- `network/`: API client and network configurations.
- `widgets/`: Reusable UI components used across multiple features.
- `utils/`: Helper functions and extensions.

### 2. Features (`lib/features/`)
Each feature (Client, Driver, Auth, etc.) is isolated and contains its own layers:

- **Data Layer**: Repositories, Models, and Data Sources.
- **Domain Layer**: Entities, Use Cases, and Repository Interfaces.
- **Presentation Layer**: BLoC/State Management, Pages, and Widgets.

## Key Features
- **Client App**: Ride booking, orders, profile, and viloyat taxi services.
- **Driver App**: Dashboard, order requests, and driver list.

## Design System
The app uses design tokens (colors and typography) extracted directly from Figma to ensure UI consistency.

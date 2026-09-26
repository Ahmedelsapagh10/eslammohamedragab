# Core

`core` contains code that is shared by the whole application. Feature-specific
code stays inside its feature, even if it may be reused later.

## Folders

- `api`: HTTP transport, interceptors, endpoints, and status codes.
- `error`: Shared failures and transport exceptions.
- `initialization`: Application startup only.
- `notification_services`: Push and local notification integration.
- `preferences`: Local and secure storage.
- `services`: Reusable device or platform capabilities.
- `utils`: Small app-wide utilities and constants.
- `widgets`: Reusable UI components with no feature business logic.

## Rules

- Do not add feature models, repositories, Cubits, or screens here.
- Keep imports explicit; do not create a global `exports.dart` barrel.
- Do not keep commented examples or placeholder implementations.
- Add shared code only when it has a real app-wide responsibility.

# Jet Framework - Features Documentation

This directory contains detailed documentation for each feature of the Jet framework. These documents serve as a reference for understanding the design decisions, architecture, and implementation details of each feature.

## Purpose

- **Design Reference:** Understanding why features were built the way they were
- **Architecture Guide:** How different components interact
- **Development Aid:** Helping you understand the codebase when adding features
- **Maintenance Guide:** Making it easier to debug and improve existing features

## Documentation Structure

Each feature has its own documentation file that includes:

1. **Overview:** What the feature does and why it exists
2. **Architecture:** How it's designed and structured
3. **Key Components:** Main classes, functions, and their responsibilities
4. **Usage Examples:** How to use the feature
5. **Performance Considerations:** Important performance aspects
6. **Common Pitfalls:** Things to watch out for
7. **Future Improvements:** Planned enhancements

## Features Documented

### Core Framework
- [Bootstrap & Lifecycle](./01_bootstrap_lifecycle.md) - App initialization and lifecycle management
- [Dependency Injection](./02_dependency_injection.md) - Riverpod integration and providers
- [Configuration](./03_configuration.md) - JetConfig and app-wide settings

### Networking
- [API Service](./04_api_service.md) - HTTP client abstraction
- [Error Handling](./05_error_handling.md) - Network error management
- [Interceptors](./06_interceptors.md) - Request/response interceptors

### State Management
- [JetBuilder](./07_jet_builder.md) - Declarative UI state management
- [JetPaginator](./08_jet_paginator.md) - Infinite scroll pagination
- [JetConsumer](./09_jet_consumer.md) - Widget consumer pattern

### Forms
- [JetFormNotifier](./10_form_notifier.md) - Form state management
- [Form Validation](./11_form_validation.md) - Validation system
- [Form Inputs](./12_form_inputs.md) - Custom input widgets

### Storage
- [JetStorage](./13_storage.md) - Persistent storage layer
- [JetCache](./14_cache.md) - Caching system
- [Secure Storage](./15_secure_storage.md) - Encrypted storage

### Notifications
- [Notification System](./16_notifications.md) - Local notifications
- [Notification Events](./17_notification_events.md) - Event-based notification handling

### Session & Security
- [Session Management](./18_session_management.md) - User session handling
- [App Locker](./19_app_locker.md) - Biometric app locking

### UI Components
- [Theme System](./20_theme_system.md) - Theme management
- [Localization](./21_localization.md) - Multi-language support
- [Navigation](./22_navigation.md) - Routing system
- [Widgets](./23_widgets.md) - Reusable UI components

### Utilities
- [Extensions](./24_extensions.md) - Dart extensions
- [Helpers](./25_helpers.md) - Helper utilities
- [Logger](./26_logger.md) - Logging system

## How to Use This Documentation

1. **When Adding Features:** Read related feature docs to understand the patterns
2. **When Debugging:** Check the architecture and common pitfalls sections
3. **When Optimizing:** Review performance considerations
4. **When Reviewing Code:** Use as reference for design decisions

## Contributing to Documentation

When adding new features:

1. Create a new markdown file following the naming convention
2. Use the template provided in `_template.md`
3. Update this README with a link to your documentation
4. Keep documentation in sync with code changes

## Quick Reference

### Finding Information

- **How does X work?** → Check the Architecture section of the feature doc
- **How do I use X?** → Check the Usage Examples section
- **Why is X slow?** → Check Performance Considerations
- **X is not working** → Check Common Pitfalls
- **How can X be improved?** → Check Future Improvements

---

**Last Updated:** October 1, 2025  
**Framework Version:** v0.0.3-alpha.2


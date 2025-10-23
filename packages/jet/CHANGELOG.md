# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.1.0-alpha.3] - 2025-01-27

### Added
- **Multi-environment configuration system** with comprehensive environment management
- **Environment adapter system** for flexible configuration across different environments
- **Enhanced JetBuilder optimization** with improved performance and type safety
- **Pull-to-refresh indicator improvements** with proper async operation handling
- **JetConsumerWidget enhancements** with direct jet parameter passing
- **Adapter initializer system** for streamlined bootstrap process
- **Enhanced notification system** with improved event handling and configuration

### Changed
- **Refactored configuration system** with environment-based management
- **Improved bootstrap process** with new adapter initialization pattern
- **Enhanced state management** with better consumer widget integration
- **Optimized performance** across multiple components
- **Updated notification adapters** with improved error handling

### Fixed
- **Pull-to-refresh timing issues** - indicator now properly waits for async operations
- **State management improvements** with better type safety
- **Configuration loading issues** with enhanced environment handling
- **Documentation inconsistencies** across multiple guides

### Documentation
- **Added comprehensive environment configuration guide**
- **Enhanced README** with table of contents and improved structure
- **Updated routing and theming documentation**
- **Simplified debugging section** with better examples
- **Removed version numbers** from documentation for cleaner maintenance
- **Replaced Faker with LoggerObserver** in Helpers documentation

## [0.0.3-alpha.2] - 2025-01-27

### Added
- **Event-driven notification system** with `JetNotificationEvent` abstract class
- **Notification event registry** for centralized event management
- **Notification configuration system** with `NotificationEventConfig`
- **Notification observer pattern** for custom event handling and analytics
- **Comprehensive notification lifecycle** (onTap, onReceive, onAction, onDismiss)
- **Payload validation** with automatic error handling
- **Category-based organization** and priority management for notifications
- **Enhanced debugging tools** with stack trace formatting
- **Type-safe form management** with `JetFormBuilder` and enhanced input components
- **State management widgets** with `JetBuilder` for lists, grids, and single items
- **Infinite scroll pagination** with `JetPaginator`
- **Theme and localization management** with persistent storage
- **Security features** with app locking and biometric authentication
- **Session management** with built-in authentication providers
- **Storage system** with secure and regular storage options
- **Networking layer** with type-safe HTTP client and configurable logging

### Changed
- Updated to Riverpod 3 for enhanced state management
- Improved error handling across all modules
- Enhanced documentation with comprehensive examples

### Fixed
- Resolved various linting issues and code quality improvements
- Fixed unused imports and code warnings

## [0.0.1] - 2024-12-01

### Added
- Initial release
- Basic framework structure
- Core configuration system
- Basic adapters and extensions

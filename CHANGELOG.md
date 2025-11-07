# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

### Changed

### Deprecated

### Removed
- Redundant pana.yml workflow (functionality merged into CI workflow)
- Publish workflow (publishing now handled manually)

### Fixed

### Security

## [0.1.0] - 2025-11-06

### Added
- GitHub Actions CI workflow for pana analysis and package verification
- Platform tests across Ubuntu, macOS, and Windows
- Demo GIFs in README showcasing basic forms, conditional fields, validators, and all field types
- Package topics for better discoverability on pub.dev (form, validation, flutter, widgets, dynamic-forms)
- Enhanced .gitignore following pub.dev best practices

### Changed
- Updated Dart SDK requirement to >=3.8.0
- Updated Flutter SDK requirement to >=3.32.0
- Increased test coverage threshold from 80% to 90%
- Added explicit platform declarations in pubspec.yaml (Android, iOS, Web, Windows, macOS, Linux)
- Updated CI workflow to use Flutter 3.32.0 (matching minimum SDK requirement) instead of 3.10.0
- Pinned `subosito/flutter-action` to v2.13.0 for consistent behavior
- Simplified CI workflow to focus on pana analysis and dry publish verification
- Improved CI workflow organization and clarity

### Fixed
- Resolved ambiguous export for FormBuilderPlusState
- Fixed library directive linting issues
- Improved code quality and linting compliance
- Fixed CI workflow cancellation issues by adding timeout configurations to all jobs
- Improved CI reliability by using pinned action versions
- Removed redundant `dart analyze` step in CI workflow (flutter analyze already includes it)
- Added permissions configuration to all GitHub Actions workflows for better security
- Optimized pana workflow to run analysis only once instead of twice
- Improved error reporting in pana workflow with GitHub Actions annotations
- Fixed missing web and linux platform files in example app (resolves "Missing index.html" CI error)

## [0.0.2] - 2025-08-22

### Added
- Enhanced documentation coverage (100% API documentation)
- Improved test coverage and reliability
- Better error handling and validation
- Performance optimizations

### Changed
- Updated dependencies to latest stable versions
- Improved code formatting and linting
- Enhanced example application

### Fixed
- Minor bug fixes and improvements
- Code quality improvements

## [0.0.1] - 2024-01-01

### Added
- Initial release of flutter_form_builder_plus
- Basic form builder widget with validation
- Support for various form field types
- Conditional field rendering based on form state
- Dynamic form generation from configuration
- Comprehensive validation system
- Form state management
- Field dependencies and conditional logic
- Custom field type support
- Form submission handling
- Error display and styling
- Accessibility support
- Responsive design support
- Internationalization ready
- Comprehensive documentation
- Example applications
- Unit tests and widget tests
- Integration tests
- Performance optimizations
- Null safety support

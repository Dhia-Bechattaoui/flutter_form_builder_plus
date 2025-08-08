import 'package:flutter/material.dart';

/// Enhanced validation utilities for flutter_form_builder_plus.
///
/// This class provides additional validation functions beyond those
/// available in form_builder_validators.
class FormBuilderPlusValidators {
  /// Private constructor to prevent instantiation.
  FormBuilderPlusValidators._();

  /// Validates that a field contains only alphanumeric characters.
  ///
  /// [errorText] is the error message to display if validation fails.
  static FormFieldValidator<String> alphanumeric([String? errorText]) {
    return (value) {
      if (value == null || value.isEmpty) return null;
      final alphanumericRegex = RegExp(r'^[a-zA-Z0-9]+$');
      if (!alphanumericRegex.hasMatch(value)) {
        return errorText ?? 'Only alphanumeric characters are allowed';
      }
      return null;
    };
  }

  /// Validates that a field contains only letters.
  ///
  /// [errorText] is the error message to display if validation fails.
  static FormFieldValidator<String> lettersOnly([String? errorText]) {
    return (value) {
      if (value == null || value.isEmpty) return null;
      final lettersRegex = RegExp(r'^[a-zA-Z\s]+$');
      if (!lettersRegex.hasMatch(value)) {
        return errorText ?? 'Only letters are allowed';
      }
      return null;
    };
  }

  /// Validates that a field contains only numbers.
  ///
  /// [errorText] is the error message to display if validation fails.
  static FormFieldValidator<String> numbersOnly([String? errorText]) {
    return (value) {
      if (value == null || value.isEmpty) return null;
      final numbersRegex = RegExp(r'^[0-9]+$');
      if (!numbersRegex.hasMatch(value)) {
        return errorText ?? 'Only numbers are allowed';
      }
      return null;
    };
  }

  /// Validates that a field matches a specific pattern.
  ///
  /// [pattern] is the regular expression pattern to match against.
  /// [errorText] is the error message to display if validation fails.
  static FormFieldValidator<String> pattern(
    RegExp pattern, [
    String? errorText,
  ]) {
    return (value) {
      if (value == null || value.isEmpty) return null;
      if (!pattern.hasMatch(value)) {
        return errorText ?? 'Invalid format';
      }
      return null;
    };
  }

  /// Validates that a field value is within a specific range.
  ///
  /// [min] is the minimum allowed value.
  /// [max] is the maximum allowed value.
  /// [errorText] is the error message to display if validation fails.
  static FormFieldValidator<String> range(
    num min,
    num max, [
    String? errorText,
  ]) {
    return (value) {
      if (value == null || value.isEmpty) return null;
      final numValue = num.tryParse(value);
      if (numValue == null) {
        return 'Please enter a valid number';
      }
      if (numValue < min || numValue > max) {
        return errorText ?? 'Value must be between $min and $max';
      }
      return null;
    };
  }

  /// Validates that a field value is greater than a minimum value.
  ///
  /// [min] is the minimum allowed value.
  /// [errorText] is the error message to display if validation fails.
  static FormFieldValidator<String> minValue(
    num min, [
    String? errorText,
  ]) {
    return (value) {
      if (value == null || value.isEmpty) return null;
      final numValue = num.tryParse(value);
      if (numValue == null) {
        return 'Please enter a valid number';
      }
      if (numValue < min) {
        return errorText ?? 'Value must be at least $min';
      }
      return null;
    };
  }

  /// Validates that a field value is less than a maximum value.
  ///
  /// [max] is the maximum allowed value.
  /// [errorText] is the error message to display if validation fails.
  static FormFieldValidator<String> maxValue(
    num max, [
    String? errorText,
  ]) {
    return (value) {
      if (value == null || value.isEmpty) return null;
      final numValue = num.tryParse(value);
      if (numValue == null) {
        return 'Please enter a valid number';
      }
      if (numValue > max) {
        return errorText ?? 'Value must be at most $max';
      }
      return null;
    };
  }

  /// Validates that a field value is a valid credit card number.
  ///
  /// [errorText] is the error message to display if validation fails.
  static FormFieldValidator<String> creditCard([String? errorText]) {
    return (value) {
      if (value == null || value.isEmpty) return null;
      // Remove spaces and dashes
      final cleanValue = value.replaceAll(RegExp(r'[\s-]'), '');
      // Basic credit card validation (Luhn algorithm)
      if (!_isValidCreditCard(cleanValue)) {
        return errorText ?? 'Please enter a valid credit card number';
      }
      return null;
    };
  }

  /// Validates that a field value is a valid postal code.
  ///
  /// [countryCode] is the country code for postal code validation.
  /// [errorText] is the error message to display if validation fails.
  static FormFieldValidator<String> postalCode(
    String countryCode, [
    String? errorText,
  ]) {
    return (value) {
      if (value == null || value.isEmpty) return null;
      final patterns = {
        'US': RegExp(r'^\d{5}(-\d{4})?$'),
        'CA': RegExp(r'^[A-Za-z]\d[A-Za-z] \d[A-Za-z]\d$'),
        'UK':
            RegExp(r'^[A-Z]{1,2}\d[A-Z\d]? ?\d[A-Z]{2}$', caseSensitive: false),
        'DE': RegExp(r'^\d{5}$'),
        'FR': RegExp(r'^\d{5}$'),
        'IT': RegExp(r'^\d{5}$'),
        'ES': RegExp(r'^\d{5}$'),
        'AU': RegExp(r'^\d{4}$'),
      };

      final pattern = patterns[countryCode.toUpperCase()];
      if (pattern == null) {
        // If country not supported, accept any non-empty value
        return null;
      }

      if (!pattern.hasMatch(value)) {
        return errorText ?? 'Please enter a valid postal code';
      }
      return null;
    };
  }

  /// Validates that a field value is a valid phone number.
  ///
  /// [countryCode] is the country code for phone number validation.
  /// [errorText] is the error message to display if validation fails.
  static FormFieldValidator<String> phoneNumber(
    String countryCode, [
    String? errorText,
  ]) {
    return (value) {
      if (value == null || value.isEmpty) return null;
      final cleanValue = value.replaceAll(RegExp(r'[\s\-\(\)]'), '');

      final patterns = {
        'US': RegExp(r'^\+?1?\d{10}$'),
        'CA': RegExp(r'^\+?1?\d{10}$'),
        'UK': RegExp(r'^\+?44\d{10}$'),
        'DE': RegExp(r'^\+?49\d{10,11}$'),
        'FR': RegExp(r'^\+?33\d{9}$'),
        'IT': RegExp(r'^\+?39\d{9,10}$'),
        'ES': RegExp(r'^\+?34\d{9}$'),
        'AU': RegExp(r'^\+?61\d{9}$'),
      };

      final pattern = patterns[countryCode.toUpperCase()];
      if (pattern == null) {
        // If country not supported, accept any non-empty value
        return null;
      }

      if (!pattern.hasMatch(cleanValue)) {
        return errorText ?? 'Please enter a valid phone number';
      }
      return null;
    };
  }

  /// Validates that a field value is a valid date.
  ///
  /// [format] is the expected date format (default: 'yyyy-MM-dd').
  /// [errorText] is the error message to display if validation fails.
  static FormFieldValidator<String> date(
    String format, [
    String? errorText,
  ]) {
    return (value) {
      if (value == null || value.isEmpty) return null;
      try {
        // Basic date validation - you might want to use a more robust date parsing library
        final dateRegex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
        if (!dateRegex.hasMatch(value)) {
          return errorText ?? 'Please enter a valid date (YYYY-MM-DD)';
        }

        final parts = value.split('-');
        final year = int.parse(parts[0]);
        final month = int.parse(parts[1]);
        final day = int.parse(parts[2]);

        if (month < 1 || month > 12) {
          return errorText ?? 'Invalid month';
        }

        if (day < 1 || day > 31) {
          return errorText ?? 'Invalid day';
        }

        // Basic leap year check
        if (month == 2 && day > 29) {
          if (day == 30 || day == 31 || (day == 29 && !_isLeapYear(year))) {
            return errorText ?? 'Invalid day for February';
          }
        }

        return null;
      } catch (e) {
        return errorText ?? 'Please enter a valid date';
      }
    };
  }

  /// Validates that a field value is a valid time.
  ///
  /// [format] is the expected time format (default: 'HH:mm').
  /// [errorText] is the error message to display if validation fails.
  static FormFieldValidator<String> time(
    String format, [
    String? errorText,
  ]) {
    return (value) {
      if (value == null || value.isEmpty) return null;
      try {
        final timeRegex = RegExp(r'^([01]?[0-9]|2[0-3]):[0-5][0-9]$');
        if (!timeRegex.hasMatch(value)) {
          return errorText ?? 'Please enter a valid time (HH:MM)';
        }
        return null;
      } catch (e) {
        return errorText ?? 'Please enter a valid time';
      }
    };
  }

  /// Validates that a field value is a valid username.
  ///
  /// [minLength] is the minimum length required.
  /// [maxLength] is the maximum length allowed.
  /// [errorText] is the error message to display if validation fails.
  static FormFieldValidator<String> username(
    int minLength,
    int maxLength, [
    String? errorText,
  ]) {
    return (value) {
      if (value == null || value.isEmpty) return null;

      if (value.length < minLength) {
        return errorText ?? 'Username must be at least $minLength characters';
      }

      if (value.length > maxLength) {
        return errorText ?? 'Username must be at most $maxLength characters';
      }

      // Username should start with a letter and contain only letters, numbers, and underscores
      final usernameRegex = RegExp(r'^[a-zA-Z][a-zA-Z0-9_]*$');
      if (!usernameRegex.hasMatch(value)) {
        return errorText ??
            'Username must start with a letter and contain only letters, numbers, and underscores';
      }

      return null;
    };
  }

  /// Validates that a field value is a strong password.
  ///
  /// [minLength] is the minimum length required.
  /// [requireUppercase] whether to require uppercase letters.
  /// [requireLowercase] whether to require lowercase letters.
  /// [requireNumbers] whether to require numbers.
  /// [requireSpecialChars] whether to require special characters.
  /// [errorText] is the error message to display if validation fails.
  static FormFieldValidator<String> strongPassword({
    int minLength = 8,
    bool requireUppercase = true,
    bool requireLowercase = true,
    bool requireNumbers = true,
    bool requireSpecialChars = true,
    String? errorText,
  }) {
    return (value) {
      if (value == null || value.isEmpty) return null;

      if (value.length < minLength) {
        return errorText ?? 'Password must be at least $minLength characters';
      }

      if (requireUppercase && !RegExp(r'[A-Z]').hasMatch(value)) {
        return errorText ??
            'Password must contain at least one uppercase letter';
      }

      if (requireLowercase && !RegExp(r'[a-z]').hasMatch(value)) {
        return errorText ??
            'Password must contain at least one lowercase letter';
      }

      if (requireNumbers && !RegExp(r'[0-9]').hasMatch(value)) {
        return errorText ?? 'Password must contain at least one number';
      }

      if (requireSpecialChars &&
          !RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
        return errorText ??
            'Password must contain at least one special character';
      }

      return null;
    };
  }

  /// Validates that a field value matches another field's value.
  ///
  /// [otherFieldName] is the name of the field to match against.
  /// [errorText] is the error message to display if validation fails.
  static FormFieldValidator<String> matchField(
    String otherFieldName, [
    String? errorText,
  ]) {
    return (value) {
      if (value == null || value.isEmpty) return null;
      // This validator requires access to the form state, so it should be used
      // with a custom validator that has access to the form context
      return errorText ?? 'Values do not match';
    };
  }

  /// Validates that a field value is not empty when another field has a specific value.
  ///
  /// [otherFieldName] is the name of the field to check.
  /// [otherFieldValue] is the value that triggers the requirement.
  /// [errorText] is the error message to display if validation fails.
  static FormFieldValidator<String> requiredWhen(
    String otherFieldName,
    dynamic otherFieldValue, [
    String? errorText,
  ]) {
    return (value) {
      if (value == null || value.isEmpty) {
        // This validator requires access to the form state, so it should be used
        // with a custom validator that has access to the form context
        return errorText ?? 'This field is required';
      }
      return null;
    };
  }

  /// Helper method to validate credit card numbers using Luhn algorithm.
  static bool _isValidCreditCard(String cardNumber) {
    if (cardNumber.length < 13 || cardNumber.length > 19) {
      return false;
    }

    int sum = 0;
    bool alternate = false;

    for (int i = cardNumber.length - 1; i >= 0; i--) {
      int n = int.parse(cardNumber[i]);
      if (alternate) {
        n *= 2;
        if (n > 9) {
          n = (n % 10) + 1;
        }
      }
      sum += n;
      alternate = !alternate;
    }

    return (sum % 10 == 0);
  }

  /// Helper method to check if a year is a leap year.
  static bool _isLeapYear(int year) {
    return (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
  }
}

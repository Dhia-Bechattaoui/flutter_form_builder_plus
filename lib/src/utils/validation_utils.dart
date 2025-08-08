/// Validation utility functions for form validation.
///
/// This class provides utility functions for validating form data
/// and field values with various validation rules.
class ValidationUtils {
  /// Private constructor to prevent instantiation.
  ValidationUtils._();

  /// Validates that a value is not null or empty.
  ///
  /// [value] is the value to validate.
  /// [errorMessage] is the error message to return if validation fails.
  /// Returns null if valid, error message if invalid.
  static String? required(dynamic value, [String? errorMessage]) {
    if (value == null || value.toString().trim().isEmpty) {
      return errorMessage ?? 'This field is required';
    }
    return null;
  }

  /// Validates that a value is a valid email address.
  ///
  /// [value] is the value to validate.
  /// [errorMessage] is the error message to return if validation fails.
  /// Returns null if valid, error message if invalid.
  static String? email(String? value, [String? errorMessage]) {
    if (value == null || value.isEmpty) return null;

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return errorMessage ?? 'Please enter a valid email address';
    }
    return null;
  }

  /// Validates that a value has a minimum length.
  ///
  /// [value] is the value to validate.
  /// [minLength] is the minimum required length.
  /// [errorMessage] is the error message to return if validation fails.
  /// Returns null if valid, error message if invalid.
  static String? minLength(String? value, int minLength,
      [String? errorMessage]) {
    if (value == null || value.isEmpty) return null;

    if (value.length < minLength) {
      return errorMessage ?? 'Must be at least $minLength characters';
    }
    return null;
  }

  /// Validates that a value has a maximum length.
  ///
  /// [value] is the value to validate.
  /// [maxLength] is the maximum allowed length.
  /// [errorMessage] is the error message to return if validation fails.
  /// Returns null if valid, error message if invalid.
  static String? maxLength(String? value, int maxLength,
      [String? errorMessage]) {
    if (value == null || value.isEmpty) return null;

    if (value.length > maxLength) {
      return errorMessage ?? 'Must be at most $maxLength characters';
    }
    return null;
  }

  /// Validates that a value matches a regular expression pattern.
  ///
  /// [value] is the value to validate.
  /// [pattern] is the regular expression pattern to match.
  /// [errorMessage] is the error message to return if validation fails.
  /// Returns null if valid, error message if invalid.
  static String? pattern(String? value, RegExp pattern,
      [String? errorMessage]) {
    if (value == null || value.isEmpty) return null;

    if (!pattern.hasMatch(value)) {
      return errorMessage ?? 'Invalid format';
    }
    return null;
  }

  /// Validates that a value is a valid URL.
  ///
  /// [value] is the value to validate.
  /// [errorMessage] is the error message to return if validation fails.
  /// Returns null if valid, error message if invalid.
  static String? url(String? value, [String? errorMessage]) {
    if (value == null || value.isEmpty) return null;

    final urlRegex = RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
    );
    if (!urlRegex.hasMatch(value)) {
      return errorMessage ?? 'Please enter a valid URL';
    }
    return null;
  }

  /// Validates that a value is a valid phone number.
  ///
  /// [value] is the value to validate.
  /// [errorMessage] is the error message to return if validation fails.
  /// Returns null if valid, error message if invalid.
  static String? phone(String? value, [String? errorMessage]) {
    if (value == null || value.isEmpty) return null;

    final phoneRegex = RegExp(r'^[\+]?[1-9][\d]{0,15}$');
    if (!phoneRegex.hasMatch(value.replaceAll(RegExp(r'[\s\-\(\)]'), ''))) {
      return errorMessage ?? 'Please enter a valid phone number';
    }
    return null;
  }

  /// Validates that a value is a valid number.
  ///
  /// [value] is the value to validate.
  /// [errorMessage] is the error message to return if validation fails.
  /// Returns null if valid, error message if invalid.
  static String? number(String? value, [String? errorMessage]) {
    if (value == null || value.isEmpty) return null;

    if (double.tryParse(value) == null) {
      return errorMessage ?? 'Please enter a valid number';
    }
    return null;
  }

  /// Validates that a value is greater than a minimum value.
  ///
  /// [value] is the value to validate.
  /// [min] is the minimum allowed value.
  /// [errorMessage] is the error message to return if validation fails.
  /// Returns null if valid, error message if invalid.
  static String? minValue(String? value, num min, [String? errorMessage]) {
    if (value == null || value.isEmpty) return null;

    final numValue = double.tryParse(value);
    if (numValue == null) {
      return 'Please enter a valid number';
    }

    if (numValue < min) {
      return errorMessage ?? 'Value must be at least $min';
    }
    return null;
  }

  /// Validates that a value is less than a maximum value.
  ///
  /// [value] is the value to validate.
  /// [max] is the maximum allowed value.
  /// [errorMessage] is the error message to return if validation fails.
  /// Returns null if valid, error message if invalid.
  static String? maxValue(String? value, num max, [String? errorMessage]) {
    if (value == null || value.isEmpty) return null;

    final numValue = double.tryParse(value);
    if (numValue == null) {
      return 'Please enter a valid number';
    }

    if (numValue > max) {
      return errorMessage ?? 'Value must be at most $max';
    }
    return null;
  }

  /// Validates that a value is within a range.
  ///
  /// [value] is the value to validate.
  /// [min] is the minimum allowed value.
  /// [max] is the maximum allowed value.
  /// [errorMessage] is the error message to return if validation fails.
  /// Returns null if valid, error message if invalid.
  static String? range(String? value, num min, num max,
      [String? errorMessage]) {
    if (value == null || value.isEmpty) return null;

    final numValue = double.tryParse(value);
    if (numValue == null) {
      return 'Please enter a valid number';
    }

    if (numValue < min || numValue > max) {
      return errorMessage ?? 'Value must be between $min and $max';
    }
    return null;
  }

  /// Validates that a value contains only letters.
  ///
  /// [value] is the value to validate.
  /// [errorMessage] is the error message to return if validation fails.
  /// Returns null if valid, error message if invalid.
  static String? lettersOnly(String? value, [String? errorMessage]) {
    if (value == null || value.isEmpty) return null;

    final lettersRegex = RegExp(r'^[a-zA-Z\s]+$');
    if (!lettersRegex.hasMatch(value)) {
      return errorMessage ?? 'Only letters are allowed';
    }
    return null;
  }

  /// Validates that a value contains only numbers.
  ///
  /// [value] is the value to validate.
  /// [errorMessage] is the error message to return if validation fails.
  /// Returns null if valid, error message if invalid.
  static String? numbersOnly(String? value, [String? errorMessage]) {
    if (value == null || value.isEmpty) return null;

    final numbersRegex = RegExp(r'^[0-9]+$');
    if (!numbersRegex.hasMatch(value)) {
      return errorMessage ?? 'Only numbers are allowed';
    }
    return null;
  }

  /// Validates that a value contains only alphanumeric characters.
  ///
  /// [value] is the value to validate.
  /// [errorMessage] is the error message to return if validation fails.
  /// Returns null if valid, error message if invalid.
  static String? alphanumeric(String? value, [String? errorMessage]) {
    if (value == null || value.isEmpty) return null;

    final alphanumericRegex = RegExp(r'^[a-zA-Z0-9]+$');
    if (!alphanumericRegex.hasMatch(value)) {
      return errorMessage ?? 'Only alphanumeric characters are allowed';
    }
    return null;
  }

  /// Validates that a value is a valid date.
  ///
  /// [value] is the value to validate.
  /// [format] is the expected date format.
  /// [errorMessage] is the error message to return if validation fails.
  /// Returns null if valid, error message if invalid.
  static String? date(String? value, String format, [String? errorMessage]) {
    if (value == null || value.isEmpty) return null;

    try {
      // Basic date validation
      final dateRegex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
      if (!dateRegex.hasMatch(value)) {
        return errorMessage ?? 'Please enter a valid date (YYYY-MM-DD)';
      }

      final parts = value.split('-');
      final month = int.parse(parts[1]);
      final day = int.parse(parts[2]);

      if (month < 1 || month > 12) {
        return errorMessage ?? 'Invalid month';
      }

      if (day < 1 || day > 31) {
        return errorMessage ?? 'Invalid day';
      }

      return null;
    } catch (e) {
      return errorMessage ?? 'Please enter a valid date';
    }
  }

  /// Validates that a value is a valid time.
  ///
  /// [value] is the value to validate.
  /// [format] is the expected time format.
  /// [errorMessage] is the error message to return if validation fails.
  /// Returns null if valid, error message if invalid.
  static String? time(String? value, String format, [String? errorMessage]) {
    if (value == null || value.isEmpty) return null;

    try {
      final timeRegex = RegExp(r'^([01]?[0-9]|2[0-3]):[0-5][0-9]$');
      if (!timeRegex.hasMatch(value)) {
        return errorMessage ?? 'Please enter a valid time (HH:MM)';
      }
      return null;
    } catch (e) {
      return errorMessage ?? 'Please enter a valid time';
    }
  }

  /// Validates that a value matches another value.
  ///
  /// [value] is the value to validate.
  /// [otherValue] is the value to match against.
  /// [errorMessage] is the error message to return if validation fails.
  /// Returns null if valid, error message if invalid.
  static String? match(String? value, dynamic otherValue,
      [String? errorMessage]) {
    if (value == null || value.isEmpty) return null;

    if (value != otherValue.toString()) {
      return errorMessage ?? 'Values do not match';
    }
    return null;
  }

  /// Validates that a value is not equal to another value.
  ///
  /// [value] is the value to validate.
  /// [otherValue] is the value to compare against.
  /// [errorMessage] is the error message to return if validation fails.
  /// Returns null if valid, error message if invalid.
  static String? notEqual(String? value, dynamic otherValue,
      [String? errorMessage]) {
    if (value == null || value.isEmpty) return null;

    if (value == otherValue.toString()) {
      return errorMessage ?? 'Value must be different';
    }
    return null;
  }

  /// Validates that a value is in a list of allowed values.
  ///
  /// [value] is the value to validate.
  /// [allowedValues] is the list of allowed values.
  /// [errorMessage] is the error message to return if validation fails.
  /// Returns null if valid, error message if invalid.
  static String? inList(String? value, List<dynamic> allowedValues,
      [String? errorMessage]) {
    if (value == null || value.isEmpty) return null;

    if (!allowedValues.contains(value)) {
      return errorMessage ??
          'Value must be one of: ${allowedValues.join(', ')}';
    }
    return null;
  }

  /// Validates that a value is not in a list of forbidden values.
  ///
  /// [value] is the value to validate.
  /// [forbiddenValues] is the list of forbidden values.
  /// [errorMessage] is the error message to return if validation fails.
  /// Returns null if valid, error message if invalid.
  static String? notInList(String? value, List<dynamic> forbiddenValues,
      [String? errorMessage]) {
    if (value == null || value.isEmpty) return null;

    if (forbiddenValues.contains(value)) {
      return errorMessage ??
          'Value must not be one of: ${forbiddenValues.join(', ')}';
    }
    return null;
  }

  /// Validates that a value is a valid credit card number.
  ///
  /// [value] is the value to validate.
  /// [errorMessage] is the error message to return if validation fails.
  /// Returns null if valid, error message if invalid.
  static String? creditCard(String? value, [String? errorMessage]) {
    if (value == null || value.isEmpty) return null;

    final cleanValue = value.replaceAll(RegExp(r'[\s-]'), '');
    if (!_isValidCreditCard(cleanValue)) {
      return errorMessage ?? 'Please enter a valid credit card number';
    }
    return null;
  }

  /// Validates that a value is a valid postal code.
  ///
  /// [value] is the value to validate.
  /// [countryCode] is the country code for postal code validation.
  /// [errorMessage] is the error message to return if validation fails.
  /// Returns null if valid, error message if invalid.
  static String? postalCode(String? value, String countryCode,
      [String? errorMessage]) {
    if (value == null || value.isEmpty) return null;

    final patterns = {
      'US': RegExp(r'^\d{5}(-\d{4})?$'),
      'CA': RegExp(r'^[A-Za-z]\d[A-Za-z] \d[A-Za-z]\d$'),
      'UK': RegExp(r'^[A-Z]{1,2}\d[A-Z\d]? ?\d[A-Z]{2}$', caseSensitive: false),
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
      return errorMessage ?? 'Please enter a valid postal code';
    }
    return null;
  }

  /// Validates that a value is a strong password.
  ///
  /// [value] is the value to validate.
  /// [minLength] is the minimum length required.
  /// [requireUppercase] whether to require uppercase letters.
  /// [requireLowercase] whether to require lowercase letters.
  /// [requireNumbers] whether to require numbers.
  /// [requireSpecialChars] whether to require special characters.
  /// [errorMessage] is the error message to return if validation fails.
  /// Returns null if valid, error message if invalid.
  static String? strongPassword(
    String? value, {
    int minLength = 8,
    bool requireUppercase = true,
    bool requireLowercase = true,
    bool requireNumbers = true,
    bool requireSpecialChars = true,
    String? errorMessage,
  }) {
    if (value == null || value.isEmpty) return null;

    if (value.length < minLength) {
      return errorMessage ?? 'Password must be at least $minLength characters';
    }

    if (requireUppercase && !RegExp(r'[A-Z]').hasMatch(value)) {
      return errorMessage ??
          'Password must contain at least one uppercase letter';
    }

    if (requireLowercase && !RegExp(r'[a-z]').hasMatch(value)) {
      return errorMessage ??
          'Password must contain at least one lowercase letter';
    }

    if (requireNumbers && !RegExp(r'[0-9]').hasMatch(value)) {
      return errorMessage ?? 'Password must contain at least one number';
    }

    if (requireSpecialChars &&
        !RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return errorMessage ??
          'Password must contain at least one special character';
    }

    return null;
  }

  /// Validates that a value is a valid username.
  ///
  /// [value] is the value to validate.
  /// [minLength] is the minimum length required.
  /// [maxLength] is the maximum length allowed.
  /// [errorMessage] is the error message to return if validation fails.
  /// Returns null if valid, error message if invalid.
  static String? username(
    String? value,
    int minLength,
    int maxLength, [
    String? errorMessage,
  ]) {
    if (value == null || value.isEmpty) return null;

    if (value.length < minLength) {
      return errorMessage ?? 'Username must be at least $minLength characters';
    }

    if (value.length > maxLength) {
      return errorMessage ?? 'Username must be at most $maxLength characters';
    }

    final usernameRegex = RegExp(r'^[a-zA-Z][a-zA-Z0-9_]*$');
    if (!usernameRegex.hasMatch(value)) {
      return errorMessage ??
          'Username must start with a letter and contain only letters, numbers, and underscores';
    }

    return null;
  }

  /// Combines multiple validation functions.
  ///
  /// [value] is the value to validate.
  /// [validators] is the list of validation functions.
  /// Returns the first error message found, or null if all validations pass.
  static String? combine(
      String? value, List<String? Function(String?)> validators) {
    for (final validator in validators) {
      final result = validator(value);
      if (result != null) {
        return result;
      }
    }
    return null;
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
}

/// Utility functions for form operations.
///
/// This class provides helper methods for common form operations
/// such as validation, data transformation, and form state management.
class FormUtils {
  /// Private constructor to prevent instantiation.
  FormUtils._();

  /// Validates a form field value against a list of validation rules.
  ///
  /// [value] is the field value to validate.
  /// [validators] is a list of validation functions.
  /// Returns the first error message found, or null if validation passes.
  static String? validateField(
    dynamic value,
    List<Function(dynamic)> validators,
  ) {
    for (final validator in validators) {
      final result = validator(value);
      if (result != null) {
        return result;
      }
    }
    return null;
  }

  /// Formats a field value for display.
  ///
  /// [value] is the raw field value.
  /// [format] is the format string to apply.
  /// Returns the formatted value.
  static String formatFieldValue(dynamic value, String format) {
    if (value == null) return '';

    switch (format.toLowerCase()) {
      case 'uppercase':
        return value.toString().toUpperCase();
      case 'lowercase':
        return value.toString().toLowerCase();
      case 'capitalize':
        return value.toString().split(' ').map((word) {
          if (word.isEmpty) return word;
          return word[0].toUpperCase() + word.substring(1).toLowerCase();
        }).join(' ');
      case 'phone':
        return _formatPhoneNumber(value.toString());
      case 'credit_card':
        return _formatCreditCard(value.toString());
      case 'postal_code':
        return _formatPostalCode(value.toString());
      default:
        return value.toString();
    }
  }

  /// Parses a field value from a formatted string.
  ///
  /// [value] is the formatted field value.
  /// [format] is the format string that was applied.
  /// Returns the parsed value.
  static dynamic parseFieldValue(String value, String format) {
    if (value.isEmpty) return null;

    switch (format.toLowerCase()) {
      case 'phone':
        return _parsePhoneNumber(value);
      case 'credit_card':
        return _parseCreditCard(value);
      case 'postal_code':
        return _parsePostalCode(value);
      default:
        return value;
    }
  }

  /// Generates a unique field name.
  ///
  /// [prefix] is the prefix for the field name.
  /// Returns a unique field name.
  static String generateFieldName(String prefix) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = (timestamp % 10000).toString().padLeft(4, '0');
    return '${prefix}_$random';
  }

  /// Checks if a field should be visible based on conditional rules.
  ///
  /// [fieldName] is the name of the field to check.
  /// [conditionalRules] is the list of conditional rules.
  /// [formData] is the current form data.
  /// Returns true if the field should be visible.
  static bool shouldFieldBeVisible(
    String fieldName,
    List<Map<String, dynamic>> conditionalRules,
    Map<String, dynamic> formData,
  ) {
    for (final rule in conditionalRules) {
      final targetField = rule['fieldName'] as String;
      final operator = rule['operator'] as String;
      final value = rule['value'];
      final action = rule['action'] as String;

      // Check if this rule affects the current field's visibility
      if (action != 'show' && action != 'hide') continue;

      final fieldValue = formData[targetField];
      bool conditionMet = false;

      switch (operator) {
        case 'equals':
          conditionMet = fieldValue == value;
          break;
        case 'not_equals':
          conditionMet = fieldValue != value;
          break;
        case 'contains':
          conditionMet =
              fieldValue?.toString().contains(value.toString()) ?? false;
          break;
        case 'not_contains':
          conditionMet =
              !(fieldValue?.toString().contains(value.toString()) ?? false);
          break;
        case 'greater_than':
          conditionMet =
              (fieldValue is num && value is num) ? fieldValue > value : false;
          break;
        case 'less_than':
          conditionMet =
              (fieldValue is num && value is num) ? fieldValue < value : false;
          break;
        case 'is_empty':
          conditionMet = fieldValue == null || fieldValue.toString().isEmpty;
          break;
        case 'is_not_empty':
          conditionMet = fieldValue != null && fieldValue.toString().isNotEmpty;
          break;
      }

      if (conditionMet) {
        switch (action) {
          case 'show':
            return true;
          case 'hide':
            return false;
        }
      }
    }

    return true; // Default to visible
  }

  /// Checks if a field should be enabled based on conditional rules.
  ///
  /// [fieldName] is the name of the field to check.
  /// [conditionalRules] is the list of conditional rules.
  /// [formData] is the current form data.
  /// Returns true if the field should be enabled.
  static bool shouldFieldBeEnabled(
    String fieldName,
    List<Map<String, dynamic>> conditionalRules,
    Map<String, dynamic> formData,
  ) {
    for (final rule in conditionalRules) {
      final targetField = rule['fieldName'] as String;
      final operator = rule['operator'] as String;
      final value = rule['value'];
      final action = rule['action'] as String;

      // Check if this rule affects the current field's enabled state
      if (action != 'enable' && action != 'disable') continue;

      final fieldValue = formData[targetField];
      bool conditionMet = false;

      switch (operator) {
        case 'equals':
          conditionMet = fieldValue == value;
          break;
        case 'not_equals':
          conditionMet = fieldValue != value;
          break;
        case 'contains':
          conditionMet =
              fieldValue?.toString().contains(value.toString()) ?? false;
          break;
        case 'not_contains':
          conditionMet =
              !(fieldValue?.toString().contains(value.toString()) ?? false);
          break;
        case 'greater_than':
          conditionMet =
              (fieldValue is num && value is num) ? fieldValue > value : false;
          break;
        case 'less_than':
          conditionMet =
              (fieldValue is num && value is num) ? fieldValue < value : false;
          break;
        case 'is_empty':
          conditionMet = fieldValue == null || fieldValue.toString().isEmpty;
          break;
        case 'is_not_empty':
          conditionMet = fieldValue != null && fieldValue.toString().isNotEmpty;
          break;
      }

      if (conditionMet) {
        switch (action) {
          case 'enable':
            return true;
          case 'disable':
            return false;
        }
      }
    }

    return true; // Default to enabled
  }

  /// Sorts form fields by their order property.
  ///
  /// [fields] is the list of field configurations.
  /// Returns the sorted list of fields.
  static List<Map<String, dynamic>> sortFieldsByOrder(
    List<Map<String, dynamic>> fields,
  ) {
    final sortedFields = List<Map<String, dynamic>>.from(fields);
    sortedFields.sort((a, b) {
      final orderA = a['order'] as int? ?? 0;
      final orderB = b['order'] as int? ?? 0;
      return orderA.compareTo(orderB);
    });
    return sortedFields;
  }

  /// Validates a complete form.
  ///
  /// [formData] is the form data to validate.
  /// [fieldConfigs] is the list of field configurations.
  /// Returns a map of field names to error messages.
  static Map<String, String?> validateForm(
    Map<String, dynamic> formData,
    List<Map<String, dynamic>> fieldConfigs,
  ) {
    final errors = <String, String?>{};

    for (final fieldConfig in fieldConfigs) {
      final fieldName = fieldConfig['name'] as String;
      final required = fieldConfig['required'] as bool? ?? false;
      final validators = fieldConfig['validators'] as List<dynamic>? ?? [];

      final fieldValue = formData[fieldName];

      // Check if field is required
      if (required && (fieldValue == null || fieldValue.toString().isEmpty)) {
        errors[fieldName] = 'This field is required';
        continue;
      }

      // Apply custom validators
      for (final validator in validators) {
        if (validator is Function) {
          final result = validator(fieldValue);
          if (result != null) {
            errors[fieldName] = result;
            break;
          }
        }
      }
    }

    return errors;
  }

  /// Formats a phone number for display.
  static String _formatPhoneNumber(String phone) {
    final clean = phone.replaceAll(RegExp(r'[^\d]'), '');
    if (clean.length == 10) {
      return '(${clean.substring(0, 3)}) ${clean.substring(3, 6)}-${clean.substring(6)}';
    } else if (clean.length == 11 && clean.startsWith('1')) {
      return '+1 (${clean.substring(1, 4)}) ${clean.substring(4, 7)}-${clean.substring(7)}';
    }
    return phone;
  }

  /// Parses a phone number from formatted string.
  static String _parsePhoneNumber(String phone) {
    return phone.replaceAll(RegExp(r'[^\d]'), '');
  }

  /// Formats a credit card number for display.
  static String _formatCreditCard(String card) {
    final clean = card.replaceAll(RegExp(r'[^\d]'), '');
    if (clean.length == 16) {
      return '${clean.substring(0, 4)} ${clean.substring(4, 8)} ${clean.substring(8, 12)} ${clean.substring(12)}';
    }
    return card;
  }

  /// Parses a credit card number from formatted string.
  static String _parseCreditCard(String card) {
    return card.replaceAll(RegExp(r'[^\d]'), '');
  }

  /// Formats a postal code for display.
  static String _formatPostalCode(String code) {
    final clean = code.replaceAll(RegExp(r'[^\w]'), '').toUpperCase();
    if (clean.length == 5) {
      return clean;
    } else if (clean.length == 9) {
      return '${clean.substring(0, 5)}-${clean.substring(5)}';
    }
    return code;
  }

  /// Parses a postal code from formatted string.
  static String _parsePostalCode(String code) {
    return code.replaceAll(RegExp(r'[^\w]'), '').toUpperCase();
  }
}

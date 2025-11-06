import 'package:flutter/material.dart';

/// Conditional form field widget that shows/hides based on form state.
///
/// This widget renders a form field conditionally based on the values
/// of other fields in the form.
class ConditionalFormField {
  /// Private constructor to prevent instantiation.
  ConditionalFormField._();

  /// Creates a conditional form field configuration.
  ///
  /// [field] is the field configuration to render conditionally.
  /// [conditionalRules] is the list of conditional rules.
  /// [formData] is the current form data.
  /// [onFieldChanged] is called when the field value changes.
  /// [onFieldValidated] is called when the field is validated.
  /// Returns the field widget if conditions are met, null otherwise.
  static Widget? create({
    required Map<String, dynamic> field,
    required List<Map<String, dynamic>> conditionalRules,
    required Map<String, dynamic> formData,
    required Function(String, dynamic) onFieldChanged,
    Function(String, String?)? onFieldValidated,
  }) {
    final fieldName = field['name'] as String;

    // Check if field should be visible
    if (!_shouldFieldBeVisible(fieldName, conditionalRules, formData)) {
      return null;
    }

    // Check if field should be enabled
    final isEnabled = _shouldFieldBeEnabled(
      fieldName,
      conditionalRules,
      formData,
    );

    // Create the field widget
    return _createFieldWidget(
      field: field,
      enabled: isEnabled,
      formData: formData,
      onFieldChanged: onFieldChanged,
      onFieldValidated: onFieldValidated,
    );
  }

  /// Determines if a field should be visible based on conditional rules.
  static bool _shouldFieldBeVisible(
    String fieldName,
    List<Map<String, dynamic>> conditionalRules,
    Map<String, dynamic> formData,
  ) {
    if (conditionalRules.isEmpty) {
      return true; // No rules means always visible
    }

    bool hasShowRule = false;
    bool hasHideRule = false;

    for (final rule in conditionalRules) {
      final targetField = rule['fieldName'] as String;
      final operator = rule['operator'] as String;
      final value = rule['value'];
      final action = rule['action'] as String;

      // Check if this rule affects the current field's visibility
      if (action != 'show' && action != 'hide') continue;

      if (action == 'show') hasShowRule = true;
      if (action == 'hide') hasHideRule = true;

      final fieldValue = formData[targetField];
      bool conditionMet = false;

      switch (operator) {
        case 'equals':
          // Handle bool comparison - checkbox might be null when unchecked
          if (value is bool) {
            if (value == true) {
              // Checking for true: fieldValue must be exactly true (not null or false)
              conditionMet = fieldValue == true;
            } else {
              // Checking for false: fieldValue can be false or null
              conditionMet = fieldValue == false || fieldValue == null;
            }
          } else {
            conditionMet = fieldValue == value;
          }
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
          conditionMet = (fieldValue is num && value is num)
              ? fieldValue > value
              : false;
          break;
        case 'less_than':
          conditionMet = (fieldValue is num && value is num)
              ? fieldValue < value
              : false;
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
            return true; // Condition met, show the field
          case 'hide':
            return false; // Condition met, hide the field
        }
      }
    }

    // If we have show rules but none were met, hide the field
    // If we have hide rules but none were met, show the field
    if (hasShowRule) {
      return false; // Show rule exists but condition not met, so hide
    }
    if (hasHideRule) {
      return true; // Hide rule exists but condition not met, so show
    }

    return true; // Default to visible if no visibility rules
  }

  /// Determines if a field should be enabled based on conditional rules.
  static bool _shouldFieldBeEnabled(
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
          conditionMet = (fieldValue is num && value is num)
              ? fieldValue > value
              : false;
          break;
        case 'less_than':
          conditionMet = (fieldValue is num && value is num)
              ? fieldValue < value
              : false;
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

  /// Creates a field widget based on the field configuration.
  static Widget _createFieldWidget({
    required Map<String, dynamic> field,
    required bool enabled,
    required Map<String, dynamic> formData,
    required Function(String, dynamic) onFieldChanged,
    Function(String, String?)? onFieldValidated,
  }) {
    final fieldName = field['name'] as String;
    final fieldType = field['type'] as String;
    final label = field['label'] as String?;
    final placeholder = field['placeholder'] as String?;
    final required = field['required'] as bool? ?? false;
    final validators = field['validators'] as List<dynamic>? ?? [];
    final options = field['options'] as Map<String, dynamic>? ?? {};
    final currentValue = formData[fieldName];

    switch (fieldType.toLowerCase()) {
      case 'text':
        return _buildTextField(
          fieldName: fieldName,
          label: label,
          placeholder: placeholder,
          required: required,
          enabled: enabled,
          validators: validators,
          currentValue: currentValue,
          onChanged: onFieldChanged,
          onValidated: onFieldValidated,
        );
      case 'email':
        return _buildEmailField(
          fieldName: fieldName,
          label: label,
          placeholder: placeholder,
          required: required,
          enabled: enabled,
          validators: validators,
          currentValue: currentValue,
          onChanged: onFieldChanged,
          onValidated: onFieldValidated,
        );
      case 'password':
        return _buildPasswordField(
          fieldName: fieldName,
          label: label,
          placeholder: placeholder,
          required: required,
          enabled: enabled,
          validators: validators,
          currentValue: currentValue,
          onChanged: onFieldChanged,
          onValidated: onFieldValidated,
        );
      case 'number':
        return _buildNumberField(
          fieldName: fieldName,
          label: label,
          placeholder: placeholder,
          required: required,
          enabled: enabled,
          validators: validators,
          options: options,
          currentValue: currentValue,
          onChanged: onFieldChanged,
          onValidated: onFieldValidated,
        );
      case 'textarea':
        return _buildTextAreaField(
          fieldName: fieldName,
          label: label,
          placeholder: placeholder,
          required: required,
          enabled: enabled,
          validators: validators,
          options: options,
          currentValue: currentValue,
          onChanged: onFieldChanged,
          onValidated: onFieldValidated,
        );
      case 'checkbox':
        return _buildCheckboxField(
          fieldName: fieldName,
          label: label,
          required: required,
          enabled: enabled,
          validators: validators,
          currentValue: currentValue,
          onChanged: onFieldChanged,
          onValidated: onFieldValidated,
        );
      case 'radio':
        return _buildRadioField(
          fieldName: fieldName,
          label: label,
          required: required,
          enabled: enabled,
          validators: validators,
          options: options,
          currentValue: currentValue,
          onChanged: onFieldChanged,
          onValidated: onFieldValidated,
        );
      case 'dropdown':
        return _buildDropdownField(
          fieldName: fieldName,
          label: label,
          required: required,
          enabled: enabled,
          validators: validators,
          options: options,
          currentValue: currentValue,
          onChanged: onFieldChanged,
          onValidated: onFieldValidated,
        );
      default:
        return Container(); // Return empty container for unknown field types
    }
  }

  /// Builds a text field widget.
  static Widget _buildTextField({
    required String fieldName,
    String? label,
    String? placeholder,
    required bool required,
    required bool enabled,
    required List<dynamic> validators,
    dynamic currentValue,
    required Function(String, dynamic) onChanged,
    Function(String, String?)? onValidated,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        initialValue: currentValue?.toString(),
        decoration: InputDecoration(
          labelText: label,
          hintText: placeholder,
          border: const OutlineInputBorder(),
        ),
        enabled: enabled,
        validator: (value) {
          if (required && (value == null || value.isEmpty)) {
            return 'This field is required';
          }
          // Apply custom validators here
          return null;
        },
        onChanged: (value) {
          onChanged(fieldName, value);
        },
      ),
    );
  }

  /// Builds an email field widget.
  static Widget _buildEmailField({
    required String fieldName,
    String? label,
    String? placeholder,
    required bool required,
    required bool enabled,
    required List<dynamic> validators,
    dynamic currentValue,
    required Function(String, dynamic) onChanged,
    Function(String, String?)? onValidated,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        initialValue: currentValue?.toString(),
        decoration: InputDecoration(
          labelText: label ?? 'Email',
          hintText: placeholder ?? 'Enter your email',
          border: const OutlineInputBorder(),
        ),
        enabled: enabled,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (required && (value == null || value.isEmpty)) {
            return 'Email is required';
          }
          if (value != null && value.isNotEmpty) {
            final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
            if (!emailRegex.hasMatch(value)) {
              return 'Please enter a valid email address';
            }
          }
          return null;
        },
        onChanged: (value) {
          onChanged(fieldName, value);
        },
      ),
    );
  }

  /// Builds a password field widget.
  static Widget _buildPasswordField({
    required String fieldName,
    String? label,
    String? placeholder,
    required bool required,
    required bool enabled,
    required List<dynamic> validators,
    dynamic currentValue,
    required Function(String, dynamic) onChanged,
    Function(String, String?)? onValidated,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        initialValue: currentValue?.toString(),
        decoration: InputDecoration(
          labelText: label ?? 'Password',
          hintText: placeholder ?? 'Enter your password',
          border: const OutlineInputBorder(),
        ),
        enabled: enabled,
        obscureText: true,
        validator: (value) {
          if (required && (value == null || value.isEmpty)) {
            return 'Password is required';
          }
          return null;
        },
        onChanged: (value) {
          onChanged(fieldName, value);
        },
      ),
    );
  }

  /// Builds a number field widget.
  static Widget _buildNumberField({
    required String fieldName,
    String? label,
    String? placeholder,
    required bool required,
    required bool enabled,
    required List<dynamic> validators,
    required Map<String, dynamic> options,
    dynamic currentValue,
    required Function(String, dynamic) onChanged,
    Function(String, String?)? onValidated,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        initialValue: currentValue?.toString(),
        decoration: InputDecoration(
          labelText: label,
          hintText: placeholder,
          border: const OutlineInputBorder(),
        ),
        enabled: enabled,
        keyboardType: TextInputType.number,
        validator: (value) {
          if (required && (value == null || value.isEmpty)) {
            return 'This field is required';
          }
          if (value != null && value.isNotEmpty) {
            if (double.tryParse(value) == null) {
              return 'Please enter a valid number';
            }
          }
          return null;
        },
        onChanged: (value) {
          onChanged(fieldName, value);
        },
      ),
    );
  }

  /// Builds a text area field widget.
  static Widget _buildTextAreaField({
    required String fieldName,
    String? label,
    String? placeholder,
    required bool required,
    required bool enabled,
    required List<dynamic> validators,
    required Map<String, dynamic> options,
    dynamic currentValue,
    required Function(String, dynamic) onChanged,
    Function(String, String?)? onValidated,
  }) {
    final maxLines = options['maxLines'] as int? ?? 3;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        initialValue: currentValue?.toString(),
        decoration: InputDecoration(
          labelText: label,
          hintText: placeholder,
          border: const OutlineInputBorder(),
        ),
        enabled: enabled,
        maxLines: maxLines,
        validator: (value) {
          if (required && (value == null || value.isEmpty)) {
            return 'This field is required';
          }
          return null;
        },
        onChanged: (value) {
          onChanged(fieldName, value);
        },
      ),
    );
  }

  /// Builds a checkbox field widget.
  static Widget _buildCheckboxField({
    required String fieldName,
    String? label,
    required bool required,
    required bool enabled,
    required List<dynamic> validators,
    dynamic currentValue,
    required Function(String, dynamic) onChanged,
    Function(String, String?)? onValidated,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: CheckboxListTile(
        title: Text(label ?? ''),
        value: currentValue as bool? ?? false,
        onChanged: enabled
            ? (value) {
                onChanged(fieldName, value);
              }
            : null,
      ),
    );
  }

  /// Builds a radio field widget.
  static Widget _buildRadioField({
    required String fieldName,
    String? label,
    required bool required,
    required bool enabled,
    required List<dynamic> validators,
    required Map<String, dynamic> options,
    dynamic currentValue,
    required Function(String, dynamic) onChanged,
    Function(String, String?)? onValidated,
  }) {
    final choices = options['choices'] as List<dynamic>? ?? [];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label != null) Text(label),
          ...choices.map(
            (choice) => RadioListTile<String>(
              title: Text(choice.toString()),
              value: choice.toString(),
              // ignore: deprecated_member_use
              groupValue: currentValue?.toString(),
              // ignore: deprecated_member_use
              onChanged: enabled
                  ? (value) {
                      onChanged(fieldName, value);
                    }
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds a dropdown field widget.
  static Widget _buildDropdownField({
    required String fieldName,
    String? label,
    required bool required,
    required bool enabled,
    required List<dynamic> validators,
    required Map<String, dynamic> options,
    dynamic currentValue,
    required Function(String, dynamic) onChanged,
    Function(String, String?)? onValidated,
  }) {
    final choices = options['choices'] as List<dynamic>? ?? [];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        // ignore: deprecated_member_use
        value: currentValue?.toString(),
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        items: choices
            .map(
              (choice) => DropdownMenuItem<String>(
                value: choice.toString(),
                child: Text(choice.toString()),
              ),
            )
            .toList(),
        onChanged: enabled
            ? (value) {
                onChanged(fieldName, value);
              }
            : null,
        validator: (value) {
          if (required && (value == null || value.isEmpty)) {
            return 'This field is required';
          }
          return null;
        },
      ),
    );
  }
}

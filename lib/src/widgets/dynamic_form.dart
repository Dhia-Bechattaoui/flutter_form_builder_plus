import 'package:flutter/material.dart';

/// Dynamic form widget that generates forms from configuration.
///
/// This widget creates a complete form dynamically based on a configuration
/// object, including support for conditional fields and validation.
class DynamicForm {
  /// Private constructor to prevent instantiation.
  DynamicForm._();

  /// Creates a dynamic form from configuration.
  ///
  /// [config] is the form configuration.
  /// [formData] is the current form data.
  /// [onFieldChanged] is called when a field value changes.
  /// [onFieldValidated] is called when a field is validated.
  /// [onFormSubmitted] is called when the form is submitted.
  /// [onFormReset] is called when the form is reset.
  /// Returns a form widget.
  static Widget create({
    required Map<String, dynamic> config,
    required Map<String, dynamic> formData,
    required Function(String, dynamic) onFieldChanged,
    Function(String, String?)? onFieldValidated,
    Function(Map<String, dynamic>)? onFormSubmitted,
    VoidCallback? onFormReset,
  }) {
    // final formName = config['name'] as String? ?? 'dynamic_form'; // TODO: Use for form identification
    final fields = config['fields'] as List<dynamic>? ?? [];
    final options = config['options'] as Map<String, dynamic>? ?? {};

    final autoValidate = options['autoValidate'] as bool? ?? false;
    // final skipDisabled = options['skipDisabled'] as bool? ?? true; // TODO: Use for validation skipping
    final enabled = options['enabled'] as bool? ?? true;

    return Form(
      autovalidateMode: autoValidate
          ? AutovalidateMode.onUserInteraction
          : AutovalidateMode.disabled,
      child: Column(
        children: [
          // Generate form fields
          ...fields.map((field) {
            final fieldConfig = field as Map<String, dynamic>;
            final conditionalRules =
                fieldConfig['conditionalRules'] as List<dynamic>? ?? [];

            // Check if field should be visible
            if (!_shouldFieldBeVisible(
                fieldConfig, conditionalRules, formData)) {
              return const SizedBox.shrink();
            }

            // Check if field should be enabled
            final isEnabled = enabled &&
                _shouldFieldBeEnabled(fieldConfig, conditionalRules, formData);

            // Create the field widget
            return _createFieldWidget(
              field: fieldConfig,
              enabled: isEnabled,
              formData: formData,
              onFieldChanged: onFieldChanged,
              onFieldValidated: onFieldValidated,
            );
          }).toList(),

          // Form buttons
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: enabled
                      ? () {
                          // Validate and submit form
                          final errors = _validateForm(fields, formData);
                          if (errors.isEmpty) {
                            onFormSubmitted?.call(formData);
                          }
                        }
                      : null,
                  child: const Text('Submit'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton(
                  onPressed: enabled ? onFormReset : null,
                  child: const Text('Reset'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Determines if a field should be visible based on conditional rules.
  static bool _shouldFieldBeVisible(
    Map<String, dynamic> field,
    List<dynamic> conditionalRules,
    Map<String, dynamic> formData,
  ) {
    for (final rule in conditionalRules) {
      final ruleMap = rule as Map<String, dynamic>;
      final targetField = ruleMap['fieldName'] as String;
      final operator = ruleMap['operator'] as String;
      final value = ruleMap['value'];
      final action = ruleMap['action'] as String;

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

  /// Determines if a field should be enabled based on conditional rules.
  static bool _shouldFieldBeEnabled(
    Map<String, dynamic> field,
    List<dynamic> conditionalRules,
    Map<String, dynamic> formData,
  ) {
    for (final rule in conditionalRules) {
      final ruleMap = rule as Map<String, dynamic>;
      final targetField = ruleMap['fieldName'] as String;
      final operator = ruleMap['operator'] as String;
      final value = ruleMap['value'];
      final action = ruleMap['action'] as String;

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

  /// Validates the form data against field configurations.
  static Map<String, String?> _validateForm(
    List<dynamic> fields,
    Map<String, dynamic> formData,
  ) {
    final errors = <String, String?>{};

    for (final field in fields) {
      final fieldConfig = field as Map<String, dynamic>;
      final fieldName = fieldConfig['name'] as String;
      final required = fieldConfig['required'] as bool? ?? false;
      final fieldValue = formData[fieldName];

      if (required && (fieldValue == null || fieldValue.toString().isEmpty)) {
        errors[fieldName] = 'This field is required';
      }
    }

    return errors;
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
          ...choices.map((choice) => RadioListTile<String>(
                title: Text(choice.toString()),
                value: choice.toString(),
                groupValue: currentValue?.toString(),
                onChanged: enabled
                    ? (value) {
                        onChanged(fieldName, value);
                      }
                    : null,
              )),
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
        value: currentValue?.toString(),
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        items: choices
            .map((choice) => DropdownMenuItem<String>(
                  value: choice.toString(),
                  child: Text(choice.toString()),
                ))
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

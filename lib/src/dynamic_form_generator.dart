import 'package:flutter/material.dart';

/// Dynamic form generator that creates forms from configuration.
///
/// This class provides functionality to generate form widgets dynamically
/// based on field configurations, including support for conditional fields
/// and validation.
class DynamicFormGenerator {
  /// Private constructor to prevent instantiation.
  DynamicFormGenerator._();

  /// Generates a form widget from a list of field configurations.
  ///
  /// [fieldConfigs] is the list of field configurations.
  /// [formData] is the current form data.
  /// [onFieldChanged] is called when a field value changes.
  /// [onFieldValidated] is called when a field is validated.
  /// Returns a list of form field widgets.
  static List<Widget> generateFormFields({
    required List<Map<String, dynamic>> fieldConfigs,
    required Map<String, dynamic> formData,
    required Function(String, dynamic) onFieldChanged,
    Function(String, String?)? onFieldValidated,
  }) {
    final widgets = <Widget>[];

    // Sort fields by order
    final sortedConfigs = _sortFieldsByOrder(fieldConfigs);

    for (final config in sortedConfigs) {
      final fieldName = config['name'] as String;
      final fieldType = config['type'] as String;
      final label = config['label'] as String?;
      final placeholder = config['placeholder'] as String?;
      final required = config['required'] as bool? ?? false;
      final enabled = config['enabled'] as bool? ?? true;
      // final visible = config['visible'] as bool? ?? true; // TODO: Use this for conditional visibility
      final validators = config['validators'] as List<dynamic>? ?? [];
      final conditionalRules =
          config['conditionalRules'] as List<dynamic>? ?? [];
      final options = config['options'] as Map<String, dynamic>? ?? {};
      final defaultValue = config['defaultValue'];

      // Check if field should be visible based on conditional rules
      if (!_shouldFieldBeVisible(fieldName, conditionalRules, formData)) {
        continue;
      }

      // Check if field should be enabled based on conditional rules
      final isEnabled = enabled &&
          _shouldFieldBeEnabled(fieldName, conditionalRules, formData);

      // Generate the field widget
      final fieldWidget = _generateFieldWidget(
        fieldName: fieldName,
        fieldType: fieldType,
        label: label,
        placeholder: placeholder,
        required: required,
        enabled: isEnabled,
        validators: validators,
        options: options,
        defaultValue: defaultValue,
        currentValue: formData[fieldName],
        onChanged: onFieldChanged,
        onValidated: onFieldValidated,
      );

      if (fieldWidget != null) {
        widgets.add(fieldWidget);
      }
    }

    return widgets;
  }

  /// Generates a single field widget based on configuration.
  static Widget? _generateFieldWidget({
    required String fieldName,
    required String fieldType,
    String? label,
    String? placeholder,
    required bool required,
    required bool enabled,
    required List<dynamic> validators,
    required Map<String, dynamic> options,
    dynamic defaultValue,
    dynamic currentValue,
    required Function(String, dynamic) onChanged,
    Function(String, String?)? onValidated,
  }) {
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
          onChanged: onChanged,
          onValidated: onValidated,
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
          onChanged: onChanged,
          onValidated: onValidated,
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
          onChanged: onChanged,
          onValidated: onValidated,
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
          onChanged: onChanged,
          onValidated: onValidated,
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
          onChanged: onChanged,
          onValidated: onValidated,
        );
      case 'checkbox':
        return _buildCheckboxField(
          fieldName: fieldName,
          label: label,
          required: required,
          enabled: enabled,
          validators: validators,
          currentValue: currentValue,
          onChanged: onChanged,
          onValidated: onValidated,
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
          onChanged: onChanged,
          onValidated: onValidated,
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
          onChanged: onChanged,
          onValidated: onValidated,
        );
      case 'date':
        return _buildDateField(
          fieldName: fieldName,
          label: label,
          required: required,
          enabled: enabled,
          validators: validators,
          options: options,
          currentValue: currentValue,
          onChanged: onChanged,
          onValidated: onValidated,
        );
      default:
        return null;
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
          ...choices.map((choice) => RadioListTile<String>(
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
        // ignore: deprecated_member_use
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

  /// Builds a date field widget.
  static Widget _buildDateField({
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: enabled
            ? () {
                // Date picker functionality would need BuildContext
                // For now, just show a placeholder
                onChanged(fieldName, DateTime.now().toIso8601String());
              }
            : null,
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: label ?? 'Date',
            border: const OutlineInputBorder(),
          ),
          child: Text(
            currentValue != null ? currentValue.toString() : 'Select a date',
          ),
        ),
      ),
    );
  }

  /// Sorts fields by their order property.
  static List<Map<String, dynamic>> _sortFieldsByOrder(
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

  /// Checks if a field should be visible based on conditional rules.
  static bool _shouldFieldBeVisible(
    String fieldName,
    List<dynamic> conditionalRules,
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
  static bool _shouldFieldBeEnabled(
    String fieldName,
    List<dynamic> conditionalRules,
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
}

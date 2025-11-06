import 'package:flutter/foundation.dart';

/// Enhanced form field with additional functionality.
///
/// This class provides enhanced form field functionality including
/// conditional rendering, dynamic validation, and improved state management.
class FormFieldPlus {
  /// Private constructor to prevent instantiation.
  FormFieldPlus._();

  /// Creates a field configuration.
  ///
  /// [name] is the field name.
  /// [type] is the field type.
  /// [label] is the field label.
  /// [placeholder] is the field placeholder.
  /// [required] whether the field is required.
  /// [enabled] whether the field is enabled.
  /// [visible] whether the field is visible.
  /// [validators] is the list of validators.
  /// [conditionalRules] is the list of conditional rules.
  /// [options] is the field options.
  /// [defaultValue] is the default value.
  /// [order] is the field order.
  /// Returns a field configuration map.
  static Map<String, dynamic> createField({
    required String name,
    required String type,
    String? label,
    String? placeholder,
    bool required = false,
    bool enabled = true,
    bool visible = true,
    List<String> validators = const [],
    List<Map<String, dynamic>> conditionalRules = const [],
    Map<String, dynamic> options = const {},
    dynamic defaultValue,
    int order = 0,
  }) {
    return {
      'name': name,
      'type': type,
      'label': label,
      'placeholder': placeholder,
      'required': required,
      'enabled': enabled,
      'visible': visible,
      'validators': validators,
      'conditionalRules': conditionalRules,
      'options': options,
      'defaultValue': defaultValue,
      'order': order,
    };
  }

  /// Creates a text field configuration.
  ///
  /// [name] is the field name.
  /// [label] is the field label.
  /// [placeholder] is the field placeholder.
  /// [required] whether the field is required.
  /// [enabled] whether the field is enabled.
  /// [validators] is the list of validators.
  /// [options] is the field options.
  /// [defaultValue] is the default value.
  /// [order] is the field order.
  /// Returns a text field configuration.
  static Map<String, dynamic> createTextField({
    required String name,
    String? label,
    String? placeholder,
    bool required = false,
    bool enabled = true,
    List<String> validators = const [],
    Map<String, dynamic> options = const {},
    String? defaultValue,
    int order = 0,
  }) {
    return createField(
      name: name,
      type: 'text',
      label: label,
      placeholder: placeholder,
      required: required,
      enabled: enabled,
      validators: validators,
      options: options,
      defaultValue: defaultValue,
      order: order,
    );
  }

  /// Creates an email field configuration.
  ///
  /// [name] is the field name.
  /// [label] is the field label.
  /// [placeholder] is the field placeholder.
  /// [required] whether the field is required.
  /// [enabled] whether the field is enabled.
  /// [validators] is the list of validators.
  /// [options] is the field options.
  /// [defaultValue] is the default value.
  /// [order] is the field order.
  /// Returns an email field configuration.
  static Map<String, dynamic> createEmailField({
    required String name,
    String? label,
    String? placeholder,
    bool required = false,
    bool enabled = true,
    List<String> validators = const [],
    Map<String, dynamic> options = const {},
    String? defaultValue,
    int order = 0,
  }) {
    return createField(
      name: name,
      type: 'email',
      label: label ?? 'Email',
      placeholder: placeholder ?? 'Enter your email',
      required: required,
      enabled: enabled,
      validators: validators,
      options: options,
      defaultValue: defaultValue,
      order: order,
    );
  }

  /// Creates a password field configuration.
  ///
  /// [name] is the field name.
  /// [label] is the field label.
  /// [placeholder] is the field placeholder.
  /// [required] whether the field is required.
  /// [enabled] whether the field is enabled.
  /// [validators] is the list of validators.
  /// [options] is the field options.
  /// [defaultValue] is the default value.
  /// [order] is the field order.
  /// Returns a password field configuration.
  static Map<String, dynamic> createPasswordField({
    required String name,
    String? label,
    String? placeholder,
    bool required = false,
    bool enabled = true,
    List<String> validators = const [],
    Map<String, dynamic> options = const {},
    String? defaultValue,
    int order = 0,
  }) {
    return createField(
      name: name,
      type: 'password',
      label: label ?? 'Password',
      placeholder: placeholder ?? 'Enter your password',
      required: required,
      enabled: enabled,
      validators: validators,
      options: options,
      defaultValue: defaultValue,
      order: order,
    );
  }

  /// Creates a number field configuration.
  ///
  /// [name] is the field name.
  /// [label] is the field label.
  /// [placeholder] is the field placeholder.
  /// [required] whether the field is required.
  /// [enabled] whether the field is enabled.
  /// [validators] is the list of validators.
  /// [options] is the field options.
  /// [defaultValue] is the default value.
  /// [order] is the field order.
  /// Returns a number field configuration.
  static Map<String, dynamic> createNumberField({
    required String name,
    String? label,
    String? placeholder,
    bool required = false,
    bool enabled = true,
    List<String> validators = const [],
    Map<String, dynamic> options = const {},
    num? defaultValue,
    int order = 0,
  }) {
    return createField(
      name: name,
      type: 'number',
      label: label,
      placeholder: placeholder,
      required: required,
      enabled: enabled,
      validators: validators,
      options: options,
      defaultValue: defaultValue,
      order: order,
    );
  }

  /// Creates a textarea field configuration.
  ///
  /// [name] is the field name.
  /// [label] is the field label.
  /// [placeholder] is the field placeholder.
  /// [required] whether the field is required.
  /// [enabled] whether the field is enabled.
  /// [validators] is the list of validators.
  /// [options] is the field options.
  /// [defaultValue] is the default value.
  /// [order] is the field order.
  /// Returns a textarea field configuration.
  static Map<String, dynamic> createTextAreaField({
    required String name,
    String? label,
    String? placeholder,
    bool required = false,
    bool enabled = true,
    List<String> validators = const [],
    Map<String, dynamic> options = const {},
    String? defaultValue,
    int order = 0,
  }) {
    return createField(
      name: name,
      type: 'textarea',
      label: label,
      placeholder: placeholder,
      required: required,
      enabled: enabled,
      validators: validators,
      options: options,
      defaultValue: defaultValue,
      order: order,
    );
  }

  /// Creates a checkbox field configuration.
  ///
  /// [name] is the field name.
  /// [label] is the field label.
  /// [required] whether the field is required.
  /// [enabled] whether the field is enabled.
  /// [validators] is the list of validators.
  /// [options] is the field options.
  /// [defaultValue] is the default value.
  /// [order] is the field order.
  /// Returns a checkbox field configuration.
  static Map<String, dynamic> createCheckboxField({
    required String name,
    String? label,
    bool required = false,
    bool enabled = true,
    List<String> validators = const [],
    Map<String, dynamic> options = const {},
    bool? defaultValue,
    int order = 0,
  }) {
    return createField(
      name: name,
      type: 'checkbox',
      label: label,
      required: required,
      enabled: enabled,
      validators: validators,
      options: options,
      defaultValue: defaultValue,
      order: order,
    );
  }

  /// Creates a radio field configuration.
  ///
  /// [name] is the field name.
  /// [label] is the field label.
  /// [choices] is the list of choices.
  /// [required] whether the field is required.
  /// [enabled] whether the field is enabled.
  /// [validators] is the list of validators.
  /// [options] is the field options.
  /// [defaultValue] is the default value.
  /// [order] is the field order.
  /// Returns a radio field configuration.
  static Map<String, dynamic> createRadioField({
    required String name,
    String? label,
    required List<String> choices,
    bool required = false,
    bool enabled = true,
    List<String> validators = const [],
    Map<String, dynamic> options = const {},
    String? defaultValue,
    int order = 0,
  }) {
    final fieldOptions = Map<String, dynamic>.from(options);
    fieldOptions['choices'] = choices;

    return createField(
      name: name,
      type: 'radio',
      label: label,
      required: required,
      enabled: enabled,
      validators: validators,
      options: fieldOptions,
      defaultValue: defaultValue,
      order: order,
    );
  }

  /// Creates a dropdown field configuration.
  ///
  /// [name] is the field name.
  /// [label] is the field label.
  /// [choices] is the list of choices.
  /// [required] whether the field is required.
  /// [enabled] whether the field is enabled.
  /// [validators] is the list of validators.
  /// [options] is the field options.
  /// [defaultValue] is the default value.
  /// [order] is the field order.
  /// Returns a dropdown field configuration.
  static Map<String, dynamic> createDropdownField({
    required String name,
    String? label,
    required List<String> choices,
    bool required = false,
    bool enabled = true,
    List<String> validators = const [],
    Map<String, dynamic> options = const {},
    String? defaultValue,
    int order = 0,
  }) {
    final fieldOptions = Map<String, dynamic>.from(options);
    fieldOptions['choices'] = choices;

    return createField(
      name: name,
      type: 'dropdown',
      label: label,
      required: required,
      enabled: enabled,
      validators: validators,
      options: fieldOptions,
      defaultValue: defaultValue,
      order: order,
    );
  }

  /// Creates a date field configuration.
  ///
  /// [name] is the field name.
  /// [label] is the field label.
  /// [required] whether the field is required.
  /// [enabled] whether the field is enabled.
  /// [validators] is the list of validators.
  /// [options] is the field options.
  /// [defaultValue] is the default value.
  /// [order] is the field order.
  /// Returns a date field configuration.
  static Map<String, dynamic> createDateField({
    required String name,
    String? label,
    bool required = false,
    bool enabled = true,
    List<String> validators = const [],
    Map<String, dynamic> options = const {},
    String? defaultValue,
    int order = 0,
  }) {
    return createField(
      name: name,
      type: 'date',
      label: label ?? 'Date',
      required: required,
      enabled: enabled,
      validators: validators,
      options: options,
      defaultValue: defaultValue,
      order: order,
    );
  }

  /// Validates a field configuration.
  ///
  /// [config] is the field configuration to validate.
  /// Returns true if the configuration is valid, false otherwise.
  static bool validateFieldConfig(Map<String, dynamic> config) {
    if (!config.containsKey('name')) {
      return false;
    }

    if (!config.containsKey('type')) {
      return false;
    }

    final name = config['name'] as String?;
    if (name == null || name.isEmpty) {
      return false;
    }

    final type = config['type'] as String?;
    if (type == null || type.isEmpty) {
      return false;
    }

    return true;
  }

  /// Gets the field name from a configuration.
  ///
  /// [config] is the field configuration.
  /// Returns the field name or null if not found.
  static String? getFieldName(Map<String, dynamic> config) {
    return config['name'] as String?;
  }

  /// Gets the field type from a configuration.
  ///
  /// [config] is the field configuration.
  /// Returns the field type or null if not found.
  static String? getFieldType(Map<String, dynamic> config) {
    return config['type'] as String?;
  }

  /// Gets the field label from a configuration.
  ///
  /// [config] is the field configuration.
  /// Returns the field label or null if not found.
  static String? getFieldLabel(Map<String, dynamic> config) {
    return config['label'] as String?;
  }

  /// Gets the field placeholder from a configuration.
  ///
  /// [config] is the field configuration.
  /// Returns the field placeholder or null if not found.
  static String? getFieldPlaceholder(Map<String, dynamic> config) {
    return config['placeholder'] as String?;
  }

  /// Checks if a field is required.
  ///
  /// [config] is the field configuration.
  /// Returns true if the field is required, false otherwise.
  static bool isFieldRequired(Map<String, dynamic> config) {
    return config['required'] == true;
  }

  /// Checks if a field is enabled.
  ///
  /// [config] is the field configuration.
  /// Returns true if the field is enabled, false otherwise.
  static bool isFieldEnabled(Map<String, dynamic> config) {
    return config['enabled'] != false;
  }

  /// Checks if a field is visible.
  ///
  /// [config] is the field configuration.
  /// Returns true if the field is visible, false otherwise.
  static bool isFieldVisible(Map<String, dynamic> config) {
    return config['visible'] != false;
  }

  /// Gets the field validators from a configuration.
  ///
  /// [config] is the field configuration.
  /// Returns the list of validators.
  static List<String> getFieldValidators(Map<String, dynamic> config) {
    final validators = config['validators'] as List<dynamic>? ?? [];
    return validators.map((validator) => validator.toString()).toList();
  }

  /// Gets the field conditional rules from a configuration.
  ///
  /// [config] is the field configuration.
  /// Returns the list of conditional rules.
  static List<Map<String, dynamic>> getFieldConditionalRules(
    Map<String, dynamic> config,
  ) {
    final rules = config['conditionalRules'] as List<dynamic>? ?? [];
    return rules.map((rule) => rule as Map<String, dynamic>).toList();
  }

  /// Gets the field options from a configuration.
  ///
  /// [config] is the field configuration.
  /// Returns the field options.
  static Map<String, dynamic> getFieldOptions(Map<String, dynamic> config) {
    return config['options'] as Map<String, dynamic>? ?? {};
  }

  /// Gets the field default value from a configuration.
  ///
  /// [config] is the field configuration.
  /// Returns the default value or null if not found.
  static dynamic getFieldDefaultValue(Map<String, dynamic> config) {
    return config['defaultValue'];
  }

  /// Gets the field order from a configuration.
  ///
  /// [config] is the field configuration.
  /// Returns the field order or 0 if not found.
  static int getFieldOrder(Map<String, dynamic> config) {
    return config['order'] as int? ?? 0;
  }

  /// Updates a field configuration.
  ///
  /// [config] is the original field configuration.
  /// [updates] is the map of updates to apply.
  /// Returns the updated field configuration.
  static Map<String, dynamic> updateFieldConfig(
    Map<String, dynamic> config,
    Map<String, dynamic> updates,
  ) {
    final updatedConfig = Map<String, dynamic>.from(config);
    updatedConfig.addAll(updates);
    return updatedConfig;
  }

  /// Adds a validator to a field configuration.
  ///
  /// [config] is the field configuration.
  /// [validator] is the validator to add.
  /// Returns the updated field configuration.
  static Map<String, dynamic> addValidator(
    Map<String, dynamic> config,
    String validator,
  ) {
    final updatedConfig = Map<String, dynamic>.from(config);
    final validators = List<String>.from(getFieldValidators(config));
    validators.add(validator);
    updatedConfig['validators'] = validators;
    return updatedConfig;
  }

  /// Removes a validator from a field configuration.
  ///
  /// [config] is the field configuration.
  /// [validator] is the validator to remove.
  /// Returns the updated field configuration.
  static Map<String, dynamic> removeValidator(
    Map<String, dynamic> config,
    String validator,
  ) {
    final updatedConfig = Map<String, dynamic>.from(config);
    final validators = List<String>.from(getFieldValidators(config));
    validators.remove(validator);
    updatedConfig['validators'] = validators;
    return updatedConfig;
  }

  /// Adds a conditional rule to a field configuration.
  ///
  /// [config] is the field configuration.
  /// [rule] is the conditional rule to add.
  /// Returns the updated field configuration.
  static Map<String, dynamic> addConditionalRule(
    Map<String, dynamic> config,
    Map<String, dynamic> rule,
  ) {
    final updatedConfig = Map<String, dynamic>.from(config);
    final rules = List<Map<String, dynamic>>.from(
      getFieldConditionalRules(config),
    );
    rules.add(rule);
    updatedConfig['conditionalRules'] = rules;
    return updatedConfig;
  }

  /// Removes a conditional rule from a field configuration.
  ///
  /// [config] is the field configuration.
  /// [rule] is the conditional rule to remove.
  /// Returns the updated field configuration.
  static Map<String, dynamic> removeConditionalRule(
    Map<String, dynamic> config,
    Map<String, dynamic> rule,
  ) {
    final updatedConfig = Map<String, dynamic>.from(config);
    final rules = List<Map<String, dynamic>>.from(
      getFieldConditionalRules(config),
    );
    rules.removeWhere((r) => mapEquals(r, rule));
    updatedConfig['conditionalRules'] = rules;
    return updatedConfig;
  }
}

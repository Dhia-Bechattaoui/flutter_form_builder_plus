import 'package:flutter/foundation.dart';
import 'conditional_rule.dart';

/// Configuration for a form field in the dynamic form generator.
///
/// This class defines all the properties needed to create a form field
/// dynamically, including its type, validation rules, and conditional logic.
class FormFieldConfig {
  /// Creates a new form field configuration.
  ///
  /// [name] is the unique identifier for the field.
  /// [type] determines the type of form field to render.
  /// [label] is the display label for the field.
  /// [placeholder] is the placeholder text for input fields.
  /// [validators] is a list of validation rules to apply.
  /// [conditionalRules] defines when this field should be shown/hidden.
  /// [options] contains additional configuration options.
  /// [defaultValue] is the initial value for the field.
  const FormFieldConfig({
    required this.name,
    required this.type,
    this.label,
    this.placeholder,
    this.validators = const [],
    this.conditionalRules = const [],
    this.options = const {},
    this.defaultValue,
    this.required = false,
    this.enabled = true,
    this.visible = true,
    this.order = 0,
  });

  /// The unique identifier for the field.
  final String name;

  /// The type of form field to render.
  final FormFieldType type;

  /// The display label for the field.
  final String? label;

  /// The placeholder text for input fields.
  final String? placeholder;

  /// List of validation rules to apply.
  final List<String> validators;

  /// Rules that determine when this field should be shown/hidden.
  final List<ConditionalRule> conditionalRules;

  /// Additional configuration options for the field.
  final Map<String, dynamic> options;

  /// The initial value for the field.
  final dynamic defaultValue;

  /// Whether the field is required.
  final bool required;

  /// Whether the field is enabled.
  final bool enabled;

  /// Whether the field is visible.
  final bool visible;

  /// The order of the field in the form.
  final int order;

  /// Creates a FormFieldConfig from a JSON map.
  factory FormFieldConfig.fromJson(Map<String, dynamic> json) {
    return FormFieldConfig(
      name: json['name'] as String,
      type: FormFieldType.values.firstWhere(
        (type) => type.name == json['type'],
        orElse: () => FormFieldType.text,
      ),
      label: json['label'] as String?,
      placeholder: json['placeholder'] as String?,
      validators: (json['validators'] as List<dynamic>?)?.cast<String>() ?? [],
      conditionalRules: (json['conditionalRules'] as List<dynamic>?)
              ?.map((rule) =>
                  ConditionalRule.fromJson(rule as Map<String, dynamic>))
              .toList() ??
          [],
      options: (json['options'] as Map<String, dynamic>?) ?? {},
      defaultValue: json['defaultValue'],
      required: json['required'] as bool? ?? false,
      enabled: json['enabled'] as bool? ?? true,
      visible: json['visible'] as bool? ?? true,
      order: json['order'] as int? ?? 0,
    );
  }

  /// Converts the FormFieldConfig to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type.name,
      'label': label,
      'placeholder': placeholder,
      'validators': validators,
      'conditionalRules':
          conditionalRules.map((rule) => rule.toJson()).toList(),
      'options': options,
      'defaultValue': defaultValue,
      'required': required,
      'enabled': enabled,
      'visible': visible,
      'order': order,
    };
  }

  /// Creates a copy of this FormFieldConfig with the given fields replaced.
  FormFieldConfig copyWith({
    String? name,
    FormFieldType? type,
    String? label,
    String? placeholder,
    List<String>? validators,
    List<ConditionalRule>? conditionalRules,
    Map<String, dynamic>? options,
    dynamic defaultValue,
    bool? required,
    bool? enabled,
    bool? visible,
    int? order,
  }) {
    return FormFieldConfig(
      name: name ?? this.name,
      type: type ?? this.type,
      label: label ?? this.label,
      placeholder: placeholder ?? this.placeholder,
      validators: validators ?? this.validators,
      conditionalRules: conditionalRules ?? this.conditionalRules,
      options: options ?? this.options,
      defaultValue: defaultValue ?? this.defaultValue,
      required: required ?? this.required,
      enabled: enabled ?? this.enabled,
      visible: visible ?? this.visible,
      order: order ?? this.order,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FormFieldConfig &&
        other.name == name &&
        other.type == type &&
        other.label == label &&
        other.placeholder == placeholder &&
        listEquals(other.validators, validators) &&
        listEquals(other.conditionalRules, conditionalRules) &&
        mapEquals(other.options, options) &&
        other.defaultValue == defaultValue &&
        other.required == required &&
        other.enabled == enabled &&
        other.visible == visible &&
        other.order == order;
  }

  @override
  int get hashCode {
    return Object.hash(
      name,
      type,
      label,
      placeholder,
      Object.hashAll(validators),
      Object.hashAll(conditionalRules),
      Object.hashAll(options.entries),
      defaultValue,
      required,
      enabled,
      visible,
      order,
    );
  }

  @override
  String toString() {
    return 'FormFieldConfig(name: $name, type: $type, label: $label, placeholder: $placeholder, validators: $validators, conditionalRules: $conditionalRules, options: $options, defaultValue: $defaultValue, required: $required, enabled: $enabled, visible: $visible, order: $order)';
  }
}

/// Enumeration of supported form field types.
enum FormFieldType {
  /// Text input field
  text,

  /// Email input field
  email,

  /// Password input field
  password,

  /// Number input field
  number,

  /// Phone number input field
  phone,

  /// URL input field
  url,

  /// Multi-line text input field
  textarea,

  /// Checkbox field
  checkbox,

  /// Radio button group
  radio,

  /// Dropdown/select field
  dropdown,

  /// Date picker field
  date,

  /// Time picker field
  time,

  /// DateTime picker field
  datetime,

  /// File upload field
  file,

  /// Custom field type
  custom,
}

/// Extension methods for FormFieldType.
extension FormFieldTypeExtension on FormFieldType {
  /// Returns the display name for the field type.
  String get displayName {
    switch (this) {
      case FormFieldType.text:
        return 'Text';
      case FormFieldType.email:
        return 'Email';
      case FormFieldType.password:
        return 'Password';
      case FormFieldType.number:
        return 'Number';
      case FormFieldType.phone:
        return 'Phone';
      case FormFieldType.url:
        return 'URL';
      case FormFieldType.textarea:
        return 'Text Area';
      case FormFieldType.checkbox:
        return 'Checkbox';
      case FormFieldType.radio:
        return 'Radio';
      case FormFieldType.dropdown:
        return 'Dropdown';
      case FormFieldType.date:
        return 'Date';
      case FormFieldType.time:
        return 'Time';
      case FormFieldType.datetime:
        return 'Date & Time';
      case FormFieldType.file:
        return 'File';
      case FormFieldType.custom:
        return 'Custom';
    }
  }

  /// Returns whether this field type supports validation.
  bool get supportsValidation {
    switch (this) {
      case FormFieldType.text:
      case FormFieldType.email:
      case FormFieldType.password:
      case FormFieldType.number:
      case FormFieldType.phone:
      case FormFieldType.url:
      case FormFieldType.textarea:
        return true;
      case FormFieldType.checkbox:
      case FormFieldType.radio:
      case FormFieldType.dropdown:
      case FormFieldType.date:
      case FormFieldType.time:
      case FormFieldType.datetime:
      case FormFieldType.file:
      case FormFieldType.custom:
        return false;
    }
  }
}

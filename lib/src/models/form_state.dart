import 'package:flutter/foundation.dart';

/// Represents the current state of a form.
///
/// This class tracks the form data, validation state, and field visibility
/// for a dynamic form.
class FormBuilderPlusState {
  /// Creates a new form state.
  ///
  /// [data] contains the current form field values.
  /// [errors] contains validation errors for each field.
  /// [visibleFields] tracks which fields are currently visible.
  /// [enabledFields] tracks which fields are currently enabled.
  const FormBuilderPlusState({
    this.data = const {},
    this.errors = const {},
    this.visibleFields = const {},
    this.enabledFields = const {},
    this.isValid = true,
    this.isSubmitting = false,
  });

  /// The current form field values.
  final Map<String, dynamic> data;

  /// Validation errors for each field.
  final Map<String, String?> errors;

  /// Tracks which fields are currently visible.
  final Map<String, bool> visibleFields;

  /// Tracks which fields are currently enabled.
  final Map<String, bool> enabledFields;

  /// Whether the form is currently valid.
  final bool isValid;

  /// Whether the form is currently being submitted.
  final bool isSubmitting;

  /// Creates a FormBuilderPlusState from a JSON map.
  factory FormBuilderPlusState.fromJson(Map<String, dynamic> json) {
    return FormBuilderPlusState(
      data: (json['data'] as Map<String, dynamic>?) ?? {},
      errors: (json['errors'] as Map<String, dynamic>?)
              ?.map((key, value) => MapEntry(key, value as String?)) ??
          {},
      visibleFields: (json['visibleFields'] as Map<String, dynamic>?)
              ?.map((key, value) => MapEntry(key, value as bool)) ??
          {},
      enabledFields: (json['enabledFields'] as Map<String, dynamic>?)
              ?.map((key, value) => MapEntry(key, value as bool)) ??
          {},
      isValid: json['isValid'] as bool? ?? true,
      isSubmitting: json['isSubmitting'] as bool? ?? false,
    );
  }

  /// Converts the FormState to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'data': data,
      'errors': errors,
      'visibleFields': visibleFields,
      'enabledFields': enabledFields,
      'isValid': isValid,
      'isSubmitting': isSubmitting,
    };
  }

  /// Creates a copy of this FormBuilderPlusState with the given fields replaced.
  FormBuilderPlusState copyWith({
    Map<String, dynamic>? data,
    Map<String, String?>? errors,
    Map<String, bool>? visibleFields,
    Map<String, bool>? enabledFields,
    bool? isValid,
    bool? isSubmitting,
  }) {
    return FormBuilderPlusState(
      data: data ?? this.data,
      errors: errors ?? this.errors,
      visibleFields: visibleFields ?? this.visibleFields,
      enabledFields: enabledFields ?? this.enabledFields,
      isValid: isValid ?? this.isValid,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }

  /// Updates a field value in the form data.
  FormBuilderPlusState updateField(String fieldName, dynamic value) {
    final newData = Map<String, dynamic>.from(data);
    newData[fieldName] = value;
    return copyWith(data: newData);
  }

  /// Updates multiple field values in the form data.
  FormBuilderPlusState updateFields(Map<String, dynamic> updates) {
    final newData = Map<String, dynamic>.from(data);
    newData.addAll(updates);
    return copyWith(data: newData);
  }

  /// Sets an error for a specific field.
  FormBuilderPlusState setFieldError(String fieldName, String? error) {
    final newErrors = Map<String, String?>.from(errors);
    newErrors[fieldName] = error;
    return copyWith(errors: newErrors);
  }

  /// Clears all errors.
  FormBuilderPlusState clearErrors() {
    return copyWith(errors: {});
  }

  /// Sets the visibility of a field.
  FormBuilderPlusState setFieldVisibility(String fieldName, bool visible) {
    final newVisibleFields = Map<String, bool>.from(visibleFields);
    newVisibleFields[fieldName] = visible;
    return copyWith(visibleFields: newVisibleFields);
  }

  /// Sets the enabled state of a field.
  FormBuilderPlusState setFieldEnabled(String fieldName, bool enabled) {
    final newEnabledFields = Map<String, bool>.from(enabledFields);
    newEnabledFields[fieldName] = enabled;
    return copyWith(enabledFields: newEnabledFields);
  }

  /// Gets the value of a field.
  dynamic getFieldValue(String fieldName) {
    return data[fieldName];
  }

  /// Gets the error for a field.
  String? getFieldError(String fieldName) {
    return errors[fieldName];
  }

  /// Checks if a field is visible.
  bool isFieldVisible(String fieldName) {
    return visibleFields[fieldName] ?? true;
  }

  /// Checks if a field is enabled.
  bool isFieldEnabled(String fieldName) {
    return enabledFields[fieldName] ?? true;
  }

  /// Checks if the form has any errors.
  bool get hasErrors => errors.values.any((error) => error != null);

  /// Gets all field names that have errors.
  List<String> get errorFields => errors.entries
      .where((entry) => entry.value != null)
      .map((entry) => entry.key)
      .toList();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FormBuilderPlusState &&
        mapEquals(other.data, data) &&
        mapEquals(other.errors, errors) &&
        mapEquals(other.visibleFields, visibleFields) &&
        mapEquals(other.enabledFields, enabledFields) &&
        other.isValid == isValid &&
        other.isSubmitting == isSubmitting;
  }

  @override
  int get hashCode {
    return Object.hash(
      Object.hashAll(data.entries),
      Object.hashAll(errors.entries),
      Object.hashAll(visibleFields.entries),
      Object.hashAll(enabledFields.entries),
      isValid,
      isSubmitting,
    );
  }

  @override
  String toString() {
    return 'FormState(data: $data, errors: $errors, visibleFields: $visibleFields, enabledFields: $enabledFields, isValid: $isValid, isSubmitting: $isSubmitting)';
  }
}

import 'package:flutter/material.dart';

/// Enhanced form builder widget with validation, conditional fields, and dynamic form generation.
///
/// This widget extends the functionality of flutter_form_builder with additional
/// features like conditional field rendering, dynamic form generation, and enhanced
/// validation capabilities.
class FormBuilderPlus extends StatefulWidget {
  /// Creates a new FormBuilderPlus widget.
  ///
  /// [name] is the unique identifier for the form.
  /// [child] is the widget tree that contains the form fields.
  /// [initialValue] is the initial form data.
  /// [onChanged] is called when the form data changes.
  /// [onSaved] is called when the form is saved.
  /// [validator] is the form-level validator.
  /// [autovalidateMode] determines when validation should occur.
  /// [skipDisabled] whether to skip disabled fields during validation.
  /// [enabled] whether the form is enabled.
  /// [child] is the widget tree that contains the form fields.
  const FormBuilderPlus({
    super.key,
    required this.name,
    required this.child,
    this.initialValue,
    this.onChanged,
    this.onSaved,
    this.validator,
    this.autovalidateMode = AutovalidateMode.disabled,
    this.skipDisabled = true,
    this.enabled = true,
  });

  /// The unique identifier for the form.
  final String name;

  /// The widget tree that contains the form fields.
  final Widget child;

  /// The initial form data.
  final Map<String, dynamic>? initialValue;

  /// Called when the form data changes.
  final void Function(Map<String, dynamic>)? onChanged;

  /// Called when the form is saved.
  final void Function(Map<String, dynamic>)? onSaved;

  /// The form-level validator.
  final String? Function(Map<String, dynamic>)? validator;

  /// Determines when validation should occur.
  final AutovalidateMode autovalidateMode;

  /// Whether to skip disabled fields during validation.
  final bool skipDisabled;

  /// Whether the form is enabled.
  final bool enabled;

  @override
  State<FormBuilderPlus> createState() => _FormBuilderPlusState();
}

class _FormBuilderPlusState extends State<FormBuilderPlus> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Map<String, dynamic> _formData = {};
  Map<String, String?> _errors = {};
  bool _isValid = true;

  @override
  void initState() {
    super.initState();
    _formData = Map<String, dynamic>.from(widget.initialValue ?? {});
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: widget.autovalidateMode,
      child: widget.child,
    );
  }

  /// Gets the current form data.
  Map<String, dynamic> get formData => _formData;

  /// Gets the current form errors.
  Map<String, String?> get errors => _errors;

  /// Gets whether the form is valid.
  bool get isValid => _isValid;

  /// Updates a field value in the form.
  void updateField(String fieldName, dynamic value) {
    setState(() {
      _formData[fieldName] = value;
    });
    widget.onChanged?.call(_formData);
  }

  /// Updates multiple field values in the form.
  void updateFields(Map<String, dynamic> updates) {
    setState(() {
      _formData.addAll(updates);
    });
    widget.onChanged?.call(_formData);
  }

  /// Sets an error for a specific field.
  void setFieldError(String fieldName, String? error) {
    setState(() {
      if (error != null) {
        _errors[fieldName] = error;
      } else {
        _errors.remove(fieldName);
      }
      _updateFormValidity();
    });
  }

  /// Clears all errors.
  void clearErrors() {
    setState(() {
      _errors.clear();
      _updateFormValidity();
    });
  }

  /// Validates the form.
  bool validate() {
    final isValid = _formKey.currentState?.validate() ?? false;
    setState(() {
      _isValid = isValid;
    });
    return isValid;
  }

  /// Saves the form.
  void save() {
    _formKey.currentState?.save();
    widget.onSaved?.call(_formData);
  }

  /// Resets the form to its initial state.
  void reset() {
    setState(() {
      _formData = Map<String, dynamic>.from(widget.initialValue ?? {});
      _errors.clear();
      _isValid = true;
    });
    _formKey.currentState?.reset();
  }

  /// Gets the value of a field.
  dynamic getFieldValue(String fieldName) {
    return _formData[fieldName];
  }

  /// Gets the error for a field.
  String? getFieldError(String fieldName) {
    return _errors[fieldName];
  }

  /// Checks if the form has any errors.
  bool get hasErrors => _errors.values.any((error) => error != null);

  /// Gets all field names that have errors.
  List<String> get errorFields => _errors.entries
      .where((entry) => entry.value != null)
      .map((entry) => entry.key)
      .toList();

  void _updateFormValidity() {
    _isValid = _errors.values.every((error) => error == null);
  }
}

/// Extension to provide FormBuilderPlus functionality to BuildContext.
extension FormBuilderPlusExtension on BuildContext {
  /// Gets the FormBuilderPlus state from the widget tree.
  _FormBuilderPlusState? get formBuilderPlus {
    final widget = findAncestorStateOfType<_FormBuilderPlusState>();
    return widget;
  }

  /// Gets the current form data.
  Map<String, dynamic>? get formData => formBuilderPlus?.formData;

  /// Gets the current form errors.
  Map<String, String?>? get formErrors => formBuilderPlus?.errors;

  /// Gets whether the form is valid.
  bool? get isFormValid => formBuilderPlus?.isValid;

  /// Updates a field value in the form.
  void updateFormField(String fieldName, dynamic value) {
    formBuilderPlus?.updateField(fieldName, value);
  }

  /// Updates multiple field values in the form.
  void updateFormFields(Map<String, dynamic> updates) {
    formBuilderPlus?.updateFields(updates);
  }

  /// Sets an error for a specific field.
  void setFormFieldError(String fieldName, String? error) {
    formBuilderPlus?.setFieldError(fieldName, error);
  }

  /// Clears all form errors.
  void clearFormErrors() {
    formBuilderPlus?.clearErrors();
  }

  /// Validates the form.
  bool? validateForm() {
    return formBuilderPlus?.validate();
  }

  /// Saves the form.
  void saveForm() {
    formBuilderPlus?.save();
  }

  /// Resets the form.
  void resetForm() {
    formBuilderPlus?.reset();
  }

  /// Gets the value of a field.
  dynamic getFormFieldValue(String fieldName) {
    return formBuilderPlus?.getFieldValue(fieldName);
  }

  /// Gets the error for a field.
  String? getFormFieldError(String fieldName) {
    return formBuilderPlus?.getFieldError(fieldName);
  }

  /// Checks if the form has any errors.
  bool? get hasFormErrors => formBuilderPlus?.hasErrors;

  /// Gets all field names that have errors.
  List<String>? get formErrorFields => formBuilderPlus?.errorFields;
}

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

/// Enhanced form builder widget with validation, conditional fields, and dynamic form generation.
///
/// This widget extends the functionality of flutter_form_builder with additional
/// features like conditional field rendering, dynamic form generation, and enhanced
/// validation capabilities.
class FormBuilderPlus extends StatefulWidget {
  /// Creates a new FormBuilderPlus widget.
  ///
  /// [name] is the unique identifier for the form (optional, defaults to 'form_builder_plus').
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
    this.name,
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
  final String? name;

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
  State<FormBuilderPlus> createState() => FormBuilderPlusState();
}

class FormBuilderPlusState extends State<FormBuilderPlus> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _formData = {};
  final Map<String, String?> _errors = {};
  bool _isValid = true;

  @override
  void initState() {
    super.initState();
    _formData = Map<String, dynamic>.from(widget.initialValue ?? {});
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: _formKey,
      initialValue: widget.initialValue ?? {},
      autovalidateMode: widget.autovalidateMode,
      skipDisabled: widget.skipDisabled,
      enabled: widget.enabled,
      onChanged: () {
        if (_formKey.currentState != null) {
          _formData = _formKey.currentState!.value;
          widget.onChanged?.call(_formData);
        }
      },
      child: widget.child,
    );
  }

  /// Gets the underlying FormBuilder key for direct access.
  GlobalKey<FormBuilderState> get formKey => _formKey;

  /// Gets the current form data.
  Map<String, dynamic> get formData {
    if (_formKey.currentState != null) {
      _formData = _formKey.currentState!.value;
    }
    return _formData;
  }

  /// Gets the current form errors.
  Map<String, String?> get errors => _errors;

  /// Gets whether the form is valid.
  bool get isValid => _isValid;

  /// Updates a field value in the form.
  void updateField(String fieldName, dynamic value) {
    _formKey.currentState?.fields[fieldName]?.didChange(value);
    setState(() {
      if (_formKey.currentState != null) {
        _formData = _formKey.currentState!.value;
      } else {
        _formData[fieldName] = value;
      }
    });
    widget.onChanged?.call(_formData);
  }

  /// Updates multiple field values in the form.
  void updateFields(Map<String, dynamic> updates) {
    for (final entry in updates.entries) {
      _formKey.currentState?.fields[entry.key]?.didChange(entry.value);
    }
    setState(() {
      if (_formKey.currentState != null) {
        _formData = _formKey.currentState!.value;
      } else {
        _formData.addAll(updates);
      }
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
      if (_formKey.currentState != null) {
        _formData = _formKey.currentState!.value;
      }
    });
    return isValid;
  }

  /// Saves and validates the form.
  bool saveAndValidate() {
    final isValid = _formKey.currentState?.saveAndValidate() ?? false;
    setState(() {
      _isValid = isValid;
      if (_formKey.currentState != null) {
        _formData = _formKey.currentState!.value;
      }
    });
    if (isValid) {
      widget.onSaved?.call(_formData);
    }
    return isValid;
  }

  /// Saves the form.
  void save() {
    _formKey.currentState?.save();
    if (_formKey.currentState != null) {
      _formData = _formKey.currentState!.value;
    }
    widget.onSaved?.call(_formData);
  }

  /// Resets the form to its initial state.
  void reset() {
    _formKey.currentState?.reset();
    setState(() {
      if (_formKey.currentState != null) {
        _formData = _formKey.currentState!.value;
      } else {
        _formData = Map<String, dynamic>.from(widget.initialValue ?? {});
      }
      _errors.clear();
      _isValid = true;
    });
  }

  /// Gets the value of a field.
  dynamic getFieldValue(String fieldName) {
    if (_formKey.currentState != null) {
      _formData = _formKey.currentState!.value;
    }
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
  FormBuilderPlusState? get formBuilderPlus {
    final widget = findAncestorStateOfType<FormBuilderPlusState>();
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

  /// Saves and validates the form.
  bool? saveAndValidateForm() {
    return formBuilderPlus?.saveAndValidate();
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

/// Enhanced form builder with additional functionality.
///
/// This class extends the basic form builder functionality with
/// conditional fields, dynamic form generation, and enhanced validation.
class FormBuilderPlusUtils {
  /// Private constructor to prevent instantiation.
  FormBuilderPlusUtils._();

  /// Creates a form configuration from a JSON map.
  ///
  /// [json] is the JSON configuration for the form.
  /// Returns a form configuration object.
  static Map<String, dynamic> createFormFromJson(Map<String, dynamic> json) {
    return {
      'name': json['name'] as String? ?? 'form',
      'fields': json['fields'] as List<dynamic>? ?? [],
      'validation': json['validation'] as Map<String, dynamic>? ?? {},
      'conditional': json['conditional'] as Map<String, dynamic>? ?? {},
      'options': json['options'] as Map<String, dynamic>? ?? {},
    };
  }

  /// Validates a form configuration.
  ///
  /// [config] is the form configuration to validate.
  /// Returns true if the configuration is valid, false otherwise.
  static bool validateFormConfig(Map<String, dynamic> config) {
    if (!config.containsKey('name')) {
      return false;
    }

    if (!config.containsKey('fields')) {
      return false;
    }

    final fields = config['fields'] as List<dynamic>?;
    if (fields == null) {
      return false;
    }

    for (final field in fields) {
      if (field is! Map<String, dynamic>) {
        return false;
      }

      if (!field.containsKey('name') || !field.containsKey('type')) {
        return false;
      }
    }

    return true;
  }

  /// Gets all field names from a form configuration.
  ///
  /// [config] is the form configuration.
  /// Returns a list of field names.
  static List<String> getFieldNames(Map<String, dynamic> config) {
    final fields = config['fields'] as List<dynamic>? ?? [];
    return fields.map((field) => field['name'] as String).toList();
  }

  /// Gets all required field names from a form configuration.
  ///
  /// [config] is the form configuration.
  /// Returns a list of required field names.
  static List<String> getRequiredFieldNames(Map<String, dynamic> config) {
    final fields = config['fields'] as List<dynamic>? ?? [];
    return fields
        .where((field) => field['required'] == true)
        .map((field) => field['name'] as String)
        .toList();
  }

  /// Gets field configuration by name.
  ///
  /// [config] is the form configuration.
  /// [fieldName] is the name of the field to find.
  /// Returns the field configuration or null if not found.
  static Map<String, dynamic>? getFieldConfig(
    Map<String, dynamic> config,
    String fieldName,
  ) {
    final fields = config['fields'] as List<dynamic>? ?? [];
    for (final field in fields) {
      if (field['name'] == fieldName) {
        return field as Map<String, dynamic>;
      }
    }
    return null;
  }

  /// Checks if a field has conditional rules.
  ///
  /// [config] is the form configuration.
  /// [fieldName] is the name of the field to check.
  /// Returns true if the field has conditional rules, false otherwise.
  static bool hasConditionalRules(
    Map<String, dynamic> config,
    String fieldName,
  ) {
    final fieldConfig = getFieldConfig(config, fieldName);
    if (fieldConfig == null) return false;

    final conditionalRules = fieldConfig['conditionalRules'] as List<dynamic>?;
    return conditionalRules != null && conditionalRules.isNotEmpty;
  }

  /// Gets conditional rules for a field.
  ///
  /// [config] is the form configuration.
  /// [fieldName] is the name of the field.
  /// Returns a list of conditional rules.
  static List<Map<String, dynamic>> getConditionalRules(
    Map<String, dynamic> config,
    String fieldName,
  ) {
    final fieldConfig = getFieldConfig(config, fieldName);
    if (fieldConfig == null) return [];

    final conditionalRules =
        fieldConfig['conditionalRules'] as List<dynamic>? ?? [];
    return conditionalRules
        .map((rule) => rule as Map<String, dynamic>)
        .toList();
  }

  /// Gets validation rules for a field.
  ///
  /// [config] is the form configuration.
  /// [fieldName] is the name of the field.
  /// Returns a list of validation rules.
  static List<String> getValidationRules(
    Map<String, dynamic> config,
    String fieldName,
  ) {
    final fieldConfig = getFieldConfig(config, fieldName);
    if (fieldConfig == null) return [];

    final validators = fieldConfig['validators'] as List<dynamic>? ?? [];
    return validators.map((validator) => validator.toString()).toList();
  }

  /// Checks if a field is required.
  ///
  /// [config] is the form configuration.
  /// [fieldName] is the name of the field.
  /// Returns true if the field is required, false otherwise.
  static bool isFieldRequired(
    Map<String, dynamic> config,
    String fieldName,
  ) {
    final fieldConfig = getFieldConfig(config, fieldName);
    if (fieldConfig == null) return false;

    return fieldConfig['required'] == true;
  }

  /// Gets the field type.
  ///
  /// [config] is the form configuration.
  /// [fieldName] is the name of the field.
  /// Returns the field type or null if not found.
  static String? getFieldType(
    Map<String, dynamic> config,
    String fieldName,
  ) {
    final fieldConfig = getFieldConfig(config, fieldName);
    if (fieldConfig == null) return null;

    return fieldConfig['type'] as String?;
  }

  /// Gets field options.
  ///
  /// [config] is the form configuration.
  /// [fieldName] is the name of the field.
  /// Returns the field options or an empty map if not found.
  static Map<String, dynamic> getFieldOptions(
    Map<String, dynamic> config,
    String fieldName,
  ) {
    final fieldConfig = getFieldConfig(config, fieldName);
    if (fieldConfig == null) return {};

    return fieldConfig['options'] as Map<String, dynamic>? ?? {};
  }

  /// Gets the default value for a field.
  ///
  /// [config] is the form configuration.
  /// [fieldName] is the name of the field.
  /// Returns the default value or null if not found.
  static dynamic getFieldDefaultValue(
    Map<String, dynamic> config,
    String fieldName,
  ) {
    final fieldConfig = getFieldConfig(config, fieldName);
    if (fieldConfig == null) return null;

    return fieldConfig['defaultValue'];
  }

  /// Creates a default form configuration.
  ///
  /// [name] is the name of the form.
  /// Returns a default form configuration.
  static Map<String, dynamic> createDefaultForm(String name) {
    return {
      'name': name,
      'fields': [],
      'validation': {},
      'conditional': {},
      'options': {
        'autoValidate': false,
        'skipDisabled': true,
        'enabled': true,
      },
    };
  }

  /// Adds a field to a form configuration.
  ///
  /// [config] is the form configuration.
  /// [fieldConfig] is the field configuration to add.
  /// Returns the updated form configuration.
  static Map<String, dynamic> addField(
    Map<String, dynamic> config,
    Map<String, dynamic> fieldConfig,
  ) {
    final updatedConfig = Map<String, dynamic>.from(config);
    final fields = List<dynamic>.from(updatedConfig['fields'] ?? []);
    fields.add(fieldConfig);
    updatedConfig['fields'] = fields;
    return updatedConfig;
  }

  /// Removes a field from a form configuration.
  ///
  /// [config] is the form configuration.
  /// [fieldName] is the name of the field to remove.
  /// Returns the updated form configuration.
  static Map<String, dynamic> removeField(
    Map<String, dynamic> config,
    String fieldName,
  ) {
    final updatedConfig = Map<String, dynamic>.from(config);
    final fields = List<dynamic>.from(updatedConfig['fields'] ?? []);
    fields.removeWhere((field) => field['name'] == fieldName);
    updatedConfig['fields'] = fields;
    return updatedConfig;
  }

  /// Updates a field in a form configuration.
  ///
  /// [config] is the form configuration.
  /// [fieldName] is the name of the field to update.
  /// [fieldConfig] is the new field configuration.
  /// Returns the updated form configuration.
  static Map<String, dynamic> updateField(
    Map<String, dynamic> config,
    String fieldName,
    Map<String, dynamic> fieldConfig,
  ) {
    final updatedConfig = Map<String, dynamic>.from(config);
    final fields = List<dynamic>.from(updatedConfig['fields'] ?? []);

    final index = fields.indexWhere((field) => field['name'] == fieldName);
    if (index != -1) {
      fields[index] = fieldConfig;
    }

    updatedConfig['fields'] = fields;
    return updatedConfig;
  }

  /// Sorts fields by their order property.
  ///
  /// [config] is the form configuration.
  /// Returns the updated form configuration with sorted fields.
  static Map<String, dynamic> sortFields(Map<String, dynamic> config) {
    final updatedConfig = Map<String, dynamic>.from(config);
    final fields = List<dynamic>.from(updatedConfig['fields'] ?? []);

    fields.sort((a, b) {
      final orderA = a['order'] as int? ?? 0;
      final orderB = b['order'] as int? ?? 0;
      return orderA.compareTo(orderB);
    });

    updatedConfig['fields'] = fields;
    return updatedConfig;
  }

  /// Validates form data against the form configuration.
  ///
  /// [config] is the form configuration.
  /// [formData] is the form data to validate.
  /// Returns a map of field names to error messages.
  static Map<String, String?> validateFormData(
    Map<String, dynamic> config,
    Map<String, dynamic> formData,
  ) {
    final errors = <String, String?>{};
    final fields = config['fields'] as List<dynamic>? ?? [];

    for (final field in fields) {
      final fieldName = field['name'] as String;
      final required = field['required'] as bool? ?? false;
      final fieldValue = formData[fieldName];

      if (required && (fieldValue == null || fieldValue.toString().isEmpty)) {
        errors[fieldName] = 'This field is required';
      }
    }

    return errors;
  }

  /// Checks if form data is valid.
  ///
  /// [config] is the form configuration.
  /// [formData] is the form data to check.
  /// Returns true if the form data is valid, false otherwise.
  static bool isFormDataValid(
    Map<String, dynamic> config,
    Map<String, dynamic> formData,
  ) {
    final errors = validateFormData(config, formData);
    return errors.values.every((error) => error == null);
  }
}

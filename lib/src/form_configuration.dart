/// Form configuration management class.
///
/// This class provides functionality for creating, validating, and managing
/// form configurations including field definitions, validation rules, and
/// conditional logic.
class FormConfiguration {
  /// Private constructor to prevent instantiation.
  FormConfiguration._();

  /// Creates a new form configuration.
  ///
  /// [name] is the form name.
  /// [fields] is the list of field configurations.
  /// [validation] is the validation configuration.
  /// [conditional] is the conditional logic configuration.
  /// [options] is the form options.
  /// Returns a form configuration map.
  static Map<String, dynamic> create({
    required String name,
    List<Map<String, dynamic>> fields = const [],
    Map<String, dynamic> validation = const {},
    Map<String, dynamic> conditional = const {},
    Map<String, dynamic> options = const {},
  }) {
    return {
      'name': name,
      'fields': fields,
      'validation': validation,
      'conditional': conditional,
      'options': {
        'autoValidate': false,
        'skipDisabled': true,
        'enabled': true,
        'showErrors': true,
        'showSuccess': false,
        ...options,
      },
    };
  }

  /// Creates a form configuration from JSON.
  ///
  /// [json] is the JSON data.
  /// Returns a form configuration map.
  static Map<String, dynamic> fromJson(Map<String, dynamic> json) {
    return {
      'name': json['name'] as String? ?? 'form',
      'fields': (json['fields'] as List<dynamic>?)
              ?.map((field) => field as Map<String, dynamic>)
              .toList() ??
          [],
      'validation': json['validation'] as Map<String, dynamic>? ?? {},
      'conditional': json['conditional'] as Map<String, dynamic>? ?? {},
      'options': json['options'] as Map<String, dynamic>? ?? {},
    };
  }

  /// Converts a form configuration to JSON.
  ///
  /// [config] is the form configuration.
  /// Returns a JSON map.
  static Map<String, dynamic> toJson(Map<String, dynamic> config) {
    return {
      'name': config['name'],
      'fields': config['fields'],
      'validation': config['validation'],
      'conditional': config['conditional'],
      'options': config['options'],
    };
  }

  /// Validates a form configuration.
  ///
  /// [config] is the form configuration to validate.
  /// Returns true if valid, false otherwise.
  static bool validate(Map<String, dynamic> config) {
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

  /// Gets the form name from configuration.
  ///
  /// [config] is the form configuration.
  /// Returns the form name.
  static String getName(Map<String, dynamic> config) {
    return config['name'] as String? ?? 'form';
  }

  /// Gets the fields from configuration.
  ///
  /// [config] is the form configuration.
  /// Returns the list of field configurations.
  static List<Map<String, dynamic>> getFields(Map<String, dynamic> config) {
    final fields = config['fields'] as List<dynamic>? ?? [];
    return fields.map((field) => field as Map<String, dynamic>).toList();
  }

  /// Gets the validation configuration.
  ///
  /// [config] is the form configuration.
  /// Returns the validation configuration.
  static Map<String, dynamic> getValidation(Map<String, dynamic> config) {
    return config['validation'] as Map<String, dynamic>? ?? {};
  }

  /// Gets the conditional configuration.
  ///
  /// [config] is the form configuration.
  /// Returns the conditional configuration.
  static Map<String, dynamic> getConditional(Map<String, dynamic> config) {
    return config['conditional'] as Map<String, dynamic>? ?? {};
  }

  /// Gets the form options.
  ///
  /// [config] is the form configuration.
  /// Returns the form options.
  static Map<String, dynamic> getOptions(Map<String, dynamic> config) {
    return config['options'] as Map<String, dynamic>? ?? {};
  }

  /// Gets a specific option value.
  ///
  /// [config] is the form configuration.
  /// [key] is the option key.
  /// [defaultValue] is the default value if not found.
  /// Returns the option value.
  static T getOption<T>(
    Map<String, dynamic> config,
    String key,
    T defaultValue,
  ) {
    final options = getOptions(config);
    return options[key] as T? ?? defaultValue;
  }

  /// Sets a form option.
  ///
  /// [config] is the form configuration.
  /// [key] is the option key.
  /// [value] is the option value.
  /// Returns the updated form configuration.
  static Map<String, dynamic> setOption(
    Map<String, dynamic> config,
    String key,
    dynamic value,
  ) {
    final updatedConfig = Map<String, dynamic>.from(config);
    final options = Map<String, dynamic>.from(getOptions(config));
    options[key] = value;
    updatedConfig['options'] = options;
    return updatedConfig;
  }

  /// Adds a field to the form configuration.
  ///
  /// [config] is the form configuration.
  /// [field] is the field configuration to add.
  /// Returns the updated form configuration.
  static Map<String, dynamic> addField(
    Map<String, dynamic> config,
    Map<String, dynamic> field,
  ) {
    final updatedConfig = Map<String, dynamic>.from(config);
    final fields = List<Map<String, dynamic>>.from(getFields(config));
    fields.add(field);
    updatedConfig['fields'] = fields;
    return updatedConfig;
  }

  /// Removes a field from the form configuration.
  ///
  /// [config] is the form configuration.
  /// [fieldName] is the name of the field to remove.
  /// Returns the updated form configuration.
  static Map<String, dynamic> removeField(
    Map<String, dynamic> config,
    String fieldName,
  ) {
    final updatedConfig = Map<String, dynamic>.from(config);
    final fields = List<Map<String, dynamic>>.from(getFields(config));
    fields.removeWhere((field) => field['name'] == fieldName);
    updatedConfig['fields'] = fields;
    return updatedConfig;
  }

  /// Updates a field in the form configuration.
  ///
  /// [config] is the form configuration.
  /// [fieldName] is the name of the field to update.
  /// [field] is the new field configuration.
  /// Returns the updated form configuration.
  static Map<String, dynamic> updateField(
    Map<String, dynamic> config,
    String fieldName,
    Map<String, dynamic> field,
  ) {
    final updatedConfig = Map<String, dynamic>.from(config);
    final fields = List<Map<String, dynamic>>.from(getFields(config));

    final index = fields.indexWhere((f) => f['name'] == fieldName);
    if (index != -1) {
      fields[index] = field;
    }

    updatedConfig['fields'] = fields;
    return updatedConfig;
  }

  /// Gets a field by name.
  ///
  /// [config] is the form configuration.
  /// [fieldName] is the name of the field to find.
  /// Returns the field configuration or null if not found.
  static Map<String, dynamic>? getField(
    Map<String, dynamic> config,
    String fieldName,
  ) {
    final fields = getFields(config);
    for (final field in fields) {
      if (field['name'] == fieldName) {
        return field;
      }
    }
    return null;
  }

  /// Gets all field names.
  ///
  /// [config] is the form configuration.
  /// Returns the list of field names.
  static List<String> getFieldNames(Map<String, dynamic> config) {
    final fields = getFields(config);
    return fields.map((field) => field['name'] as String).toList();
  }

  /// Gets required field names.
  ///
  /// [config] is the form configuration.
  /// Returns the list of required field names.
  static List<String> getRequiredFieldNames(Map<String, dynamic> config) {
    final fields = getFields(config);
    return fields
        .where((field) => field['required'] == true)
        .map((field) => field['name'] as String)
        .toList();
  }

  /// Sorts fields by their order property.
  ///
  /// [config] is the form configuration.
  /// Returns the updated form configuration with sorted fields.
  static Map<String, dynamic> sortFields(Map<String, dynamic> config) {
    final updatedConfig = Map<String, dynamic>.from(config);
    final fields = List<Map<String, dynamic>>.from(getFields(config));

    fields.sort((a, b) {
      final orderA = a['order'] as int? ?? 0;
      final orderB = b['order'] as int? ?? 0;
      return orderA.compareTo(orderB);
    });

    updatedConfig['fields'] = fields;
    return updatedConfig;
  }

  /// Creates a copy of the form configuration.
  ///
  /// [config] is the form configuration.
  /// Returns a copy of the configuration.
  static Map<String, dynamic> copy(Map<String, dynamic> config) {
    return Map<String, dynamic>.from(config);
  }

  /// Merges two form configurations.
  ///
  /// [config1] is the first form configuration.
  /// [config2] is the second form configuration.
  /// Returns the merged configuration.
  static Map<String, dynamic> merge(
    Map<String, dynamic> config1,
    Map<String, dynamic> config2,
  ) {
    final merged = Map<String, dynamic>.from(config1);

    // Merge fields
    final fields1 = getFields(config1);
    final fields2 = getFields(config2);
    final mergedFields = <Map<String, dynamic>>[];

    // Add fields from config1
    mergedFields.addAll(fields1);

    // Add fields from config2 (overwrite if name exists)
    for (final field2 in fields2) {
      final existingIndex = mergedFields.indexWhere(
        (field) => field['name'] == field2['name'],
      );
      if (existingIndex != -1) {
        mergedFields[existingIndex] = field2;
      } else {
        mergedFields.add(field2);
      }
    }

    merged['fields'] = mergedFields;

    // Merge validation
    final validation1 = getValidation(config1);
    final validation2 = getValidation(config2);
    merged['validation'] = {...validation1, ...validation2};

    // Merge conditional
    final conditional1 = getConditional(config1);
    final conditional2 = getConditional(config2);
    merged['conditional'] = {...conditional1, ...conditional2};

    // Merge options
    final options1 = getOptions(config1);
    final options2 = getOptions(config2);
    merged['options'] = {...options1, ...options2};

    return merged;
  }

  /// Validates form data against the configuration.
  ///
  /// [config] is the form configuration.
  /// [formData] is the form data to validate.
  /// Returns a map of field names to error messages.
  static Map<String, String?> validateFormData(
    Map<String, dynamic> config,
    Map<String, dynamic> formData,
  ) {
    final errors = <String, String?>{};
    final fields = getFields(config);

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
  /// Returns true if valid, false otherwise.
  static bool isFormDataValid(
    Map<String, dynamic> config,
    Map<String, dynamic> formData,
  ) {
    final errors = validateFormData(config, formData);
    return errors.values.every((error) => error == null);
  }
}

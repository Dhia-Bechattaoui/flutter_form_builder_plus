/// Conditional field functionality for dynamic form rendering.
///
/// This class provides functionality for showing or hiding form fields
/// based on conditional rules and form state.
class ConditionalField {
  /// Private constructor to prevent instantiation.
  ConditionalField._();

  /// Creates a conditional rule.
  ///
  /// [fieldName] is the name of the field to check.
  /// [operator] is the comparison operator.
  /// [value] is the value to compare against.
  /// [action] is the action to take when condition is met.
  /// Returns a conditional rule map.
  static Map<String, dynamic> createRule({
    required String fieldName,
    required String operator,
    required dynamic value,
    String action = 'show',
  }) {
    return {
      'fieldName': fieldName,
      'operator': operator,
      'value': value,
      'action': action,
    };
  }

  /// Creates a show rule (show field when condition is met).
  ///
  /// [fieldName] is the name of the field to check.
  /// [operator] is the comparison operator.
  /// [value] is the value to compare against.
  /// Returns a conditional rule map.
  static Map<String, dynamic> showWhen({
    required String fieldName,
    required String operator,
    required dynamic value,
  }) {
    return createRule(
      fieldName: fieldName,
      operator: operator,
      value: value,
      action: 'show',
    );
  }

  /// Creates a hide rule (hide field when condition is met).
  ///
  /// [fieldName] is the name of the field to check.
  /// [operator] is the comparison operator.
  /// [value] is the value to compare against.
  /// Returns a conditional rule map.
  static Map<String, dynamic> hideWhen({
    required String fieldName,
    required String operator,
    required dynamic value,
  }) {
    return createRule(
      fieldName: fieldName,
      operator: operator,
      value: value,
      action: 'hide',
    );
  }

  /// Creates an enable rule (enable field when condition is met).
  ///
  /// [fieldName] is the name of the field to check.
  /// [operator] is the comparison operator.
  /// [value] is the value to compare against.
  /// Returns a conditional rule map.
  static Map<String, dynamic> enableWhen({
    required String fieldName,
    required String operator,
    required dynamic value,
  }) {
    return createRule(
      fieldName: fieldName,
      operator: operator,
      value: value,
      action: 'enable',
    );
  }

  /// Creates a disable rule (disable field when condition is met).
  ///
  /// [fieldName] is the name of the field to check.
  /// [operator] is the comparison operator.
  /// [value] is the value to compare against.
  /// Returns a conditional rule map.
  static Map<String, dynamic> disableWhen({
    required String fieldName,
    required String operator,
    required dynamic value,
  }) {
    return createRule(
      fieldName: fieldName,
      operator: operator,
      value: value,
      action: 'disable',
    );
  }

  /// Evaluates a conditional rule against form data.
  ///
  /// [rule] is the conditional rule to evaluate.
  /// [formData] is the current form data.
  /// Returns true if the condition is met, false otherwise.
  static bool evaluateRule(
    Map<String, dynamic> rule,
    Map<String, dynamic> formData,
  ) {
    final fieldName = rule['fieldName'] as String;
    final operator = rule['operator'] as String;
    final value = rule['value'];

    final fieldValue = formData[fieldName];

    switch (operator) {
      case 'equals':
        return fieldValue == value;
      case 'not_equals':
        return fieldValue != value;
      case 'contains':
        if (fieldValue is String && value is String) {
          return fieldValue.contains(value);
        }
        return false;
      case 'not_contains':
        if (fieldValue is String && value is String) {
          return !fieldValue.contains(value);
        }
        return true;
      case 'greater_than':
        if (fieldValue is num && value is num) {
          return fieldValue > value;
        }
        return false;
      case 'less_than':
        if (fieldValue is num && value is num) {
          return fieldValue < value;
        }
        return false;
      case 'greater_than_or_equal':
        if (fieldValue is num && value is num) {
          return fieldValue >= value;
        }
        return false;
      case 'less_than_or_equal':
        if (fieldValue is num && value is num) {
          return fieldValue <= value;
        }
        return false;
      case 'is_empty':
        return fieldValue == null || fieldValue.toString().isEmpty;
      case 'is_not_empty':
        return fieldValue != null && fieldValue.toString().isNotEmpty;
      case 'is_true':
        return fieldValue == true;
      case 'is_false':
        return fieldValue == false;
      default:
        return false;
    }
  }

  /// Evaluates multiple conditional rules against form data.
  ///
  /// [rules] is the list of conditional rules to evaluate.
  /// [formData] is the current form data.
  /// [logic] is the logic to use when combining rules ('and' or 'or').
  /// Returns true if the conditions are met, false otherwise.
  static bool evaluateRules(
    List<Map<String, dynamic>> rules,
    Map<String, dynamic> formData, {
    String logic = 'and',
  }) {
    if (rules.isEmpty) return true;

    final results = rules.map((rule) => evaluateRule(rule, formData)).toList();

    switch (logic.toLowerCase()) {
      case 'and':
        return results.every((result) => result);
      case 'or':
        return results.any((result) => result);
      default:
        return results.every((result) => result);
    }
  }

  /// Determines if a field should be visible based on conditional rules.
  ///
  /// [fieldName] is the name of the field to check.
  /// [conditionalRules] is the list of conditional rules.
  /// [formData] is the current form data.
  /// Returns true if the field should be visible, false otherwise.
  static bool shouldFieldBeVisible(
    String fieldName,
    List<Map<String, dynamic>> conditionalRules,
    Map<String, dynamic> formData,
  ) {
    for (final rule in conditionalRules) {
      final action = rule['action'] as String;

      // Check if this rule affects the current field's visibility
      if (action != 'show' && action != 'hide') continue;

      final conditionMet = evaluateRule(rule, formData);

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
  ///
  /// [fieldName] is the name of the field to check.
  /// [conditionalRules] is the list of conditional rules.
  /// [formData] is the current form data.
  /// Returns true if the field should be enabled, false otherwise.
  static bool shouldFieldBeEnabled(
    String fieldName,
    List<Map<String, dynamic>> conditionalRules,
    Map<String, dynamic> formData,
  ) {
    for (final rule in conditionalRules) {
      final action = rule['action'] as String;

      // Check if this rule affects the current field's enabled state
      if (action != 'enable' && action != 'disable') continue;

      final conditionMet = evaluateRule(rule, formData);

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

  /// Gets all fields that are affected by conditional rules.
  ///
  /// [conditionalRules] is the list of conditional rules.
  /// Returns a set of field names that are affected by conditional rules.
  static Set<String> getAffectedFields(
    List<Map<String, dynamic>> conditionalRules,
  ) {
    final affectedFields = <String>{};

    for (final rule in conditionalRules) {
      final fieldName = rule['fieldName'] as String;
      affectedFields.add(fieldName);
    }

    return affectedFields;
  }

  /// Validates a conditional rule.
  ///
  /// [rule] is the conditional rule to validate.
  /// Returns true if the rule is valid, false otherwise.
  static bool validateRule(Map<String, dynamic> rule) {
    if (!rule.containsKey('fieldName')) {
      return false;
    }

    if (!rule.containsKey('operator')) {
      return false;
    }

    if (!rule.containsKey('value')) {
      return false;
    }

    if (!rule.containsKey('action')) {
      return false;
    }

    final fieldName = rule['fieldName'] as String?;
    if (fieldName == null || fieldName.isEmpty) {
      return false;
    }

    final operator = rule['operator'] as String?;
    if (operator == null || operator.isEmpty) {
      return false;
    }

    final action = rule['action'] as String?;
    if (action == null || action.isEmpty) {
      return false;
    }

    // Validate operator
    final validOperators = [
      'equals',
      'not_equals',
      'contains',
      'not_contains',
      'greater_than',
      'less_than',
      'greater_than_or_equal',
      'less_than_or_equal',
      'is_empty',
      'is_not_empty',
      'is_true',
      'is_false',
    ];

    if (!validOperators.contains(operator)) {
      return false;
    }

    // Validate action
    final validActions = ['show', 'hide', 'enable', 'disable'];
    if (!validActions.contains(action)) {
      return false;
    }

    return true;
  }

  /// Validates a list of conditional rules.
  ///
  /// [rules] is the list of conditional rules to validate.
  /// Returns a list of validation errors.
  static List<String> validateRules(List<Map<String, dynamic>> rules) {
    final errors = <String>[];

    for (int i = 0; i < rules.length; i++) {
      final rule = rules[i];
      if (!validateRule(rule)) {
        errors.add('Rule at index $i is invalid');
      }
    }

    return errors;
  }

  /// Creates a conditional rule from JSON.
  ///
  /// [json] is the JSON data.
  /// Returns a conditional rule map.
  static Map<String, dynamic> fromJson(Map<String, dynamic> json) {
    return {
      'fieldName': json['fieldName'] as String? ?? '',
      'operator': json['operator'] as String? ?? '',
      'value': json['value'],
      'action': json['action'] as String? ?? 'show',
    };
  }

  /// Converts a conditional rule to JSON.
  ///
  /// [rule] is the conditional rule.
  /// Returns a JSON map.
  static Map<String, dynamic> toJson(Map<String, dynamic> rule) {
    return {
      'fieldName': rule['fieldName'],
      'operator': rule['operator'],
      'value': rule['value'],
      'action': rule['action'],
    };
  }

  /// Creates a copy of a conditional rule.
  ///
  /// [rule] is the conditional rule to copy.
  /// Returns a copy of the rule.
  static Map<String, dynamic> copy(Map<String, dynamic> rule) {
    return Map<String, dynamic>.from(rule);
  }

  /// Updates a conditional rule.
  ///
  /// [rule] is the original conditional rule.
  /// [updates] is the map of updates to apply.
  /// Returns the updated conditional rule.
  static Map<String, dynamic> update(
    Map<String, dynamic> rule,
    Map<String, dynamic> updates,
  ) {
    final updatedRule = Map<String, dynamic>.from(rule);
    updatedRule.addAll(updates);
    return updatedRule;
  }
}

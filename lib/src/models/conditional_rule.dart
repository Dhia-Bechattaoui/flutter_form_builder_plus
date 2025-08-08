/// Defines a conditional rule for showing or hiding form fields.
///
/// This class represents a single condition that determines whether a field
/// should be visible based on the value of another field.
class ConditionalRule {
  /// Creates a new conditional rule.
  ///
  /// [fieldName] is the name of the field to check.
  /// [operator] is the comparison operator to use.
  /// [value] is the value to compare against.
  /// [action] determines what happens when the condition is met.
  const ConditionalRule({
    required this.fieldName,
    required this.operator,
    required this.value,
    this.action = ConditionalAction.show,
  });

  /// The name of the field to check for the condition.
  final String fieldName;

  /// The comparison operator to use.
  final ConditionalOperator operator;

  /// The value to compare against.
  final dynamic value;

  /// The action to take when the condition is met.
  final ConditionalAction action;

  /// Creates a ConditionalRule from a JSON map.
  factory ConditionalRule.fromJson(Map<String, dynamic> json) {
    return ConditionalRule(
      fieldName: json['fieldName'] as String,
      operator: ConditionalOperator.values.firstWhere(
        (op) => op.name == json['operator'],
        orElse: () => ConditionalOperator.equals,
      ),
      value: json['value'],
      action: ConditionalAction.values.firstWhere(
        (action) => action.name == json['action'],
        orElse: () => ConditionalAction.show,
      ),
    );
  }

  /// Converts the ConditionalRule to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'fieldName': fieldName,
      'operator': operator.name,
      'value': value,
      'action': action.name,
    };
  }

  /// Evaluates the condition against the given field value.
  ///
  /// Returns true if the condition is met, false otherwise.
  bool evaluate(dynamic fieldValue) {
    switch (operator) {
      case ConditionalOperator.equals:
        return fieldValue == value;
      case ConditionalOperator.notEquals:
        return fieldValue != value;
      case ConditionalOperator.contains:
        if (fieldValue is String && value is String) {
          return fieldValue.contains(value);
        }
        return false;
      case ConditionalOperator.notContains:
        if (fieldValue is String && value is String) {
          return !fieldValue.contains(value);
        }
        return true;
      case ConditionalOperator.greaterThan:
        if (fieldValue is num && value is num) {
          return fieldValue > value;
        }
        return false;
      case ConditionalOperator.lessThan:
        if (fieldValue is num && value is num) {
          return fieldValue < value;
        }
        return false;
      case ConditionalOperator.greaterThanOrEqual:
        if (fieldValue is num && value is num) {
          return fieldValue >= value;
        }
        return false;
      case ConditionalOperator.lessThanOrEqual:
        if (fieldValue is num && value is num) {
          return fieldValue <= value;
        }
        return false;
      case ConditionalOperator.isEmpty:
        return fieldValue == null || fieldValue.toString().isEmpty;
      case ConditionalOperator.isNotEmpty:
        return fieldValue != null && fieldValue.toString().isNotEmpty;
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ConditionalRule &&
        other.fieldName == fieldName &&
        other.operator == operator &&
        other.value == value &&
        other.action == action;
  }

  @override
  int get hashCode {
    return Object.hash(fieldName, operator, value, action);
  }

  @override
  String toString() {
    return 'ConditionalRule(fieldName: $fieldName, operator: $operator, value: $value, action: $action)';
  }
}

/// Enumeration of conditional operators.
enum ConditionalOperator {
  /// Equal to
  equals,

  /// Not equal to
  notEquals,

  /// Contains (for strings)
  contains,

  /// Does not contain (for strings)
  notContains,

  /// Greater than
  greaterThan,

  /// Less than
  lessThan,

  /// Greater than or equal to
  greaterThanOrEqual,

  /// Less than or equal to
  lessThanOrEqual,

  /// Is empty or null
  isEmpty,

  /// Is not empty and not null
  isNotEmpty,
}

/// Enumeration of conditional actions.
enum ConditionalAction {
  /// Show the field when condition is met
  show,

  /// Hide the field when condition is met
  hide,

  /// Enable the field when condition is met
  enable,

  /// Disable the field when condition is met
  disable,
}

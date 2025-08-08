import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_form_builder_plus/flutter_form_builder_plus.dart';

void main() {
  group('FormFieldConfig', () {
    test('should create from JSON', () {
      final json = {
        'name': 'email',
        'type': 'email',
        'label': 'Email',
        'required': true,
      };

      final config = FormFieldConfig.fromJson(json);
      expect(config.name, equals('email'));
      expect(config.type, equals(FormFieldType.email));
      expect(config.label, equals('Email'));
      expect(config.required, isTrue);
    });

    test('should convert to JSON', () {
      final config = FormFieldConfig(
        name: 'email',
        type: FormFieldType.email,
        label: 'Email',
        required: true,
      );

      final json = config.toJson();
      expect(json['name'], equals('email'));
      expect(json['type'], equals('email'));
      expect(json['label'], equals('Email'));
      expect(json['required'], isTrue);
    });
  });

  group('ConditionalRule', () {
    test('should create from JSON', () {
      final json = {
        'fieldName': 'userType',
        'operator': 'equals',
        'value': 'business',
        'action': 'show',
      };

      final rule = ConditionalRule.fromJson(json);
      expect(rule.fieldName, equals('userType'));
      expect(rule.operator, equals(ConditionalOperator.equals));
      expect(rule.value, equals('business'));
      expect(rule.action, equals(ConditionalAction.show));
    });

    test('should evaluate condition correctly', () {
      final rule = ConditionalRule(
        fieldName: 'userType',
        operator: ConditionalOperator.equals,
        value: 'business',
        action: ConditionalAction.show,
      );

      final result = rule.evaluate('business');
      expect(result, isTrue);
    });
  });

  group('FormBuilderPlusState', () {
    test('should create from JSON', () {
      final json = <String, dynamic>{
        'data': <String, dynamic>{'email': 'test@example.com'},
        'errors': <String, dynamic>{},
        'visibleFields': <String, dynamic>{'email': true},
        'enabledFields': <String, dynamic>{'email': true},
        'isValid': true,
        'isSubmitting': false,
      };

      final state = FormBuilderPlusState.fromJson(json);
      expect(state.data['email'], equals('test@example.com'));
      expect(state.isValid, isTrue);
      expect(state.isSubmitting, isFalse);
    });

    test('should update field value', () {
      final state = FormBuilderPlusState();
      final updatedState = state.updateField('email', 'new@example.com');

      expect(updatedState.data['email'], equals('new@example.com'));
      expect(state.data, isEmpty); // Original state unchanged
    });

    test('should set field error', () {
      final state = FormBuilderPlusState();
      final updatedState = state.setFieldError('email', 'Invalid email');

      expect(updatedState.errors['email'], equals('Invalid email'));
      expect(state.errors, isEmpty); // Original state unchanged
    });
  });

  group('ValidationUtils', () {
    test('should validate required field', () {
      final result = ValidationUtils.required('test', 'Required field');
      expect(result, isNull);
    });

    test('should validate email', () {
      final result = ValidationUtils.email('test@example.com', 'Invalid email');
      expect(result, isNull);
    });

    test('should validate min length', () {
      final result = ValidationUtils.minLength('test', 3, 'Too short');
      expect(result, isNull);
    });
  });
}

# Flutter Form Builder Plus

An enhanced form builder with validation, conditional fields, and dynamic form generation for Flutter applications.

## Features

- **Enhanced Form Building**: Extends `flutter_form_builder` with additional functionality
- **Conditional Fields**: Show/hide fields based on other field values
- **Dynamic Form Generation**: Create forms from configuration objects
- **Advanced Validation**: Comprehensive validation utilities
- **Form State Management**: Track form data, errors, and field states
- **Type Safety**: Full TypeScript-like type safety with Dart

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  flutter_form_builder_plus: ^0.0.1
```

## Quick Start

### Basic Form

```dart
import 'package:flutter/material.dart';
import 'package:flutter_form_builder_plus/flutter_form_builder_plus.dart';

class MyForm extends StatefulWidget {
  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  final _formKey = GlobalKey<FormState>();
  final _formData = <String, dynamic>{};

  @override
  Widget build(BuildContext context) {
    return FormBuilderPlus(
      key: _formKey,
      child: Column(
        children: [
          FormBuilderTextField(
            name: 'name',
            decoration: const InputDecoration(
              labelText: 'Name',
              border: OutlineInputBorder(),
            ),
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
              FormBuilderValidators.minLength(2),
            ]),
            onChanged: (value) {
              setState(() {
                _formData['name'] = value;
              });
            },
          ),
          const SizedBox(height: 16),
          FormBuilderTextField(
            name: 'email',
            decoration: const InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
              FormBuilderValidators.email(),
            ]),
            onChanged: (value) {
              setState(() {
                _formData['email'] = value;
              });
            },
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState?.saveAndValidate() ?? false) {
                print('Form data: $_formData');
              }
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
```

### Dynamic Form Generation

```dart
final config = {
  'fields': [
    {
      'name': 'username',
      'type': 'text',
      'label': 'Username',
      'required': true,
      'validators': ['required', 'minLength:3'],
    },
    {
      'name': 'age',
      'type': 'number',
      'label': 'Age',
      'required': true,
      'validators': ['required', 'minValue:18'],
    },
    {
      'name': 'country',
      'type': 'dropdown',
      'label': 'Country',
      'options': {
        'us': 'United States',
        'uk': 'United Kingdom',
        'ca': 'Canada',
      },
    },
  ],
};

DynamicForm.create(
  config: config,
  formData: _formData,
  onFieldChanged: (name, value) {
    setState(() {
      _formData[name] = value;
    });
  },
  onFormSubmitted: (data) {
    print('Form submitted: $data');
  },
);
```

### Conditional Fields

```dart
FormBuilderPlus(
  child: Column(
    children: [
      FormBuilderDropdown<String>(
        name: 'userType',
        decoration: const InputDecoration(
          labelText: 'User Type',
          border: OutlineInputBorder(),
        ),
        items: const [
          DropdownMenuItem(value: 'individual', child: Text('Individual')),
          DropdownMenuItem(value: 'business', child: Text('Business')),
        ],
        onChanged: (value) {
          setState(() {
            _formData['userType'] = value;
          });
        },
      ),
      const SizedBox(height: 16),
      ConditionalFormField.create(
        field: {
          'name': 'companyName',
          'type': 'text',
          'label': 'Company Name',
        },
        conditionalRules: [
          {
            'fieldName': 'userType',
            'operator': 'equals',
            'value': 'business',
            'action': 'show',
          },
        ],
        formData: _formData,
        onFieldChanged: (name, value) {
          setState(() {
            _formData[name] = value;
          });
        },
      ),
    ],
  ),
);
```

## API Reference

### FormBuilderPlus Widget

The main form builder widget that extends `flutter_form_builder` functionality.

```dart
class FormBuilderPlus extends StatefulWidget {
  const FormBuilderPlus({
    super.key,
    required this.child,
    this.autoValidateMode = AutovalidateMode.disabled,
    this.onChanged,
    this.onSaved,
  });
}
```

### DynamicForm

Generates forms dynamically from configuration.

```dart
class DynamicForm {
  static Widget create({
    required Map<String, dynamic> config,
    required Map<String, dynamic> formData,
    required Function(String, dynamic) onFieldChanged,
    Function(String, String?)? onFieldValidated,
    Function(Map<String, dynamic>)? onFormSubmitted,
    VoidCallback? onFormReset,
  });
}
```

### ConditionalFormField

Creates conditional form fields that show/hide based on rules.

```dart
class ConditionalFormField {
  static Widget? create({
    required Map<String, dynamic> field,
    required List<Map<String, dynamic>> conditionalRules,
    required Map<String, dynamic> formData,
    required Function(String, dynamic) onFieldChanged,
    Function(String, String?)? onFieldValidated,
  });
}
```

### FormFieldConfig

Configuration for individual form fields.

```dart
class FormFieldConfig {
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
}
```

### ConditionalRule

Defines conditions for showing/hiding fields.

```dart
class ConditionalRule {
  const ConditionalRule({
    required this.fieldName,
    required this.operator,
    required this.value,
    this.action = ConditionalAction.show,
  });
}
```

## Validation

The package provides enhanced validation utilities:

```dart
// Basic validators
FormBuilderValidators.required()
FormBuilderValidators.email()
FormBuilderValidators.minLength(3)
FormBuilderValidators.maxLength(50)

// Enhanced validators
FormBuilderPlusValidators.alphanumeric()
FormBuilderPlusValidators.lettersOnly()
FormBuilderPlusValidators.numbersOnly()
FormBuilderPlusValidators.creditCard()
FormBuilderPlusValidators.postalCode()
FormBuilderPlusValidators.phoneNumber()
FormBuilderPlusValidators.strongPassword()
```

## Form State Management

Track form state including data, errors, and field visibility:

```dart
class FormState {
  const FormState({
    this.data = const {},
    this.errors = const {},
    this.visibleFields = const {},
    this.enabledFields = const {},
    this.isValid = true,
    this.isSubmitting = false,
  });
}
```

## Utility Functions

### FormUtils

```dart
// Validate field value
bool isValid = FormUtils.validateField(value, validators);

// Format field value
String formatted = FormUtils.formatValue(value, type);

// Generate unique field name
String fieldName = FormUtils.generateFieldName(prefix);
```

### ValidationUtils

```dart
// Create validation rules
List<FormFieldValidator> validators = [
  ValidationUtils.required(),
  ValidationUtils.email(),
  ValidationUtils.minLength(3),
  ValidationUtils.pattern(r'^[a-zA-Z]+$'),
];
```

## Field Types

Supported field types for dynamic form generation:

- `text` - Text input field
- `email` - Email input field
- `password` - Password input field
- `number` - Number input field
- `textarea` - Multi-line text input
- `checkbox` - Checkbox field
- `radio` - Radio button group
- `dropdown` - Dropdown selection
- `date` - Date picker
- `time` - Time picker

## Conditional Operators

Available operators for conditional rules:

- `equals` - Field value equals specified value
- `notEquals` - Field value does not equal specified value
- `contains` - Field value contains specified value
- `notContains` - Field value does not contain specified value
- `greaterThan` - Field value is greater than specified value
- `lessThan` - Field value is less than specified value
- `greaterThanOrEqual` - Field value is greater than or equal to specified value
- `lessThanOrEqual` - Field value is less than or equal to specified value
- `isEmpty` - Field value is empty
- `isNotEmpty` - Field value is not empty

## Conditional Actions

Available actions for conditional rules:

- `show` - Show the field when condition is met
- `hide` - Hide the field when condition is met
- `enable` - Enable the field when condition is met
- `disable` - Disable the field when condition is met

## Example

See the `example/` directory for a complete working example demonstrating all features.

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

If you encounter any issues or have questions, please file an issue on the [GitHub repository](https://github.com/Dhia-Bechattaoui/flutter_form_builder_plus/issues).

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for a list of changes and version history.

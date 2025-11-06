/// An enhanced form builder with validation, conditional fields, and dynamic form generation.
///
/// This package provides a powerful and flexible form building solution for Flutter applications.
/// It extends the functionality of flutter_form_builder with additional features like conditional
/// field rendering, dynamic form generation, and enhanced validation capabilities.
///
/// ## Features
///
/// * **Enhanced Form Builder**: Build complex forms with ease
/// * **Conditional Fields**: Show/hide fields based on form state
/// * **Dynamic Form Generation**: Generate forms from configuration
/// * **Comprehensive Validation**: Built-in and custom validation support
/// * **Form State Management**: Efficient form state handling
/// * **Accessibility Support**: Full accessibility compliance
/// * **Responsive Design**: Works on all screen sizes
/// * **Internationalization Ready**: Support for multiple languages
///
/// ## Getting Started
///
/// ```dart
/// import 'package:flutter_form_builder_plus/flutter_form_builder_plus.dart';
///
/// FormBuilderPlus(
///   name: 'my_form',
///   child: Column(
///     children: [
///       FormBuilderTextField(
///         name: 'email',
///         decoration: InputDecoration(labelText: 'Email'),
///         validator: FormBuilderValidators.compose([
///           FormBuilderValidators.required(),
///           FormBuilderValidators.email(),
///         ]),
///       ),
///       FormBuilderTextField(
///         name: 'password',
///         decoration: InputDecoration(labelText: 'Password'),
///         obscureText: true,
///         validator: FormBuilderValidators.compose([
///           FormBuilderValidators.required(),
///           FormBuilderValidators.minLength(6),
///         ]),
///       ),
///     ],
///   ),
/// )
/// ```
///
/// ## Additional Information
///
/// For more information, see the [documentation](https://pub.dev/documentation/flutter_form_builder_plus).
// ignore: unnecessary_library_name
library flutter_form_builder_plus;

// Core exports
export 'src/form_builder_plus.dart';
export 'src/form_field_plus.dart';
export 'src/form_configuration.dart';
export 'src/conditional_field.dart';
export 'src/dynamic_form_generator.dart';
export 'src/validation/validators.dart';
export 'src/models/form_field_config.dart';
export 'src/models/conditional_rule.dart';
export 'src/models/form_state.dart'; // Exports FormBuilderPlusState and FormState (alias)

// Widget exports
export 'src/widgets/form_builder_plus.dart' hide FormBuilderPlusState;
export 'src/widgets/conditional_form_field.dart';
export 'src/widgets/dynamic_form.dart';

// Utility exports
export 'src/utils/form_utils.dart';
export 'src/utils/validation_utils.dart';

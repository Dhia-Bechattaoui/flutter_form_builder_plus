import 'package:flutter/material.dart';
import 'package:flutter_form_builder_plus/flutter_form_builder_plus.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Form Builder Plus Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const DemoHomePage(),
    );
  }
}

class DemoHomePage extends StatefulWidget {
  const DemoHomePage({super.key});

  @override
  State<DemoHomePage> createState() => _DemoHomePageState();
}

class _DemoHomePageState extends State<DemoHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _demos = [
    const BasicFormDemo(),
    const EnhancedValidatorsDemo(),
    const ConditionalFieldsDemo(),
    const DynamicFormDemo(),
    const AllFieldTypesDemo(),
  ];

  final List<String> _demoTitles = [
    'Basic Form',
    'Enhanced Validators',
    'Conditional Fields',
    'Dynamic Form',
    'All Field Types',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Form Builder Plus'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            labelType: NavigationRailLabelType.all,
            destinations: _demoTitles
                .map((title) => NavigationRailDestination(
                      icon: const Icon(Icons.circle_outlined),
                      selectedIcon: const Icon(Icons.circle),
                      label: Text(title),
                    ))
                .toList(),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: _demos[_selectedIndex],
          ),
        ],
      ),
    );
  }
}

// ==================== Basic Form Demo ====================
class BasicFormDemo extends StatefulWidget {
  const BasicFormDemo({super.key});

  @override
  State<BasicFormDemo> createState() => _BasicFormDemoState();
}

class _BasicFormDemoState extends State<BasicFormDemo> {
  final _formKey = GlobalKey<FormBuilderState>();
  final _formData = <String, dynamic>{};

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Basic Form with FormBuilderPlus',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Demonstrates basic form building with FormBuilderPlus widget',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          FormBuilderPlus(
            child: FormBuilder(
              key: _formKey,
              child: Column(
                children: [
                  FormBuilderTextField(
                    name: 'name',
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
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
                      prefixIcon: Icon(Icons.email),
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
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState?.saveAndValidate() ??
                                false) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Form submitted: $_formData'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            }
                          },
                          child: const Text('Submit'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            _formKey.currentState?.reset();
                            setState(() {
                              _formData.clear();
                            });
                          },
                          child: const Text('Reset'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== Enhanced Validators Demo ====================
class EnhancedValidatorsDemo extends StatefulWidget {
  const EnhancedValidatorsDemo({super.key});

  @override
  State<EnhancedValidatorsDemo> createState() => _EnhancedValidatorsDemoState();
}

class _EnhancedValidatorsDemoState extends State<EnhancedValidatorsDemo> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Enhanced Validators',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Demonstrates FormBuilderPlusValidators: alphanumeric, creditCard, postalCode, phoneNumber, strongPassword',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          FormBuilder(
            key: _formKey,
            child: Column(
              children: [
                FormBuilderTextField(
                  name: 'username',
                  decoration: const InputDecoration(
                    labelText: 'Username (alphanumeric only)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.account_circle),
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderPlusValidators.alphanumeric(),
                  ]),
                ),
                const SizedBox(height: 16),
                FormBuilderTextField(
                  name: 'creditCard',
                  decoration: const InputDecoration(
                    labelText: 'Credit Card Number',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.credit_card),
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderPlusValidators.creditCard(),
                  ]),
                ),
                const SizedBox(height: 16),
                FormBuilderTextField(
                  name: 'postalCode',
                  decoration: const InputDecoration(
                    labelText: 'Postal Code (US)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.location_on),
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderPlusValidators.postalCode('US'),
                  ]),
                ),
                const SizedBox(height: 16),
                FormBuilderTextField(
                  name: 'phone',
                  decoration: const InputDecoration(
                    labelText: 'Phone Number (US)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone),
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderPlusValidators.phoneNumber('US'),
                  ]),
                ),
                const SizedBox(height: 16),
                FormBuilderTextField(
                  name: 'password',
                  decoration: const InputDecoration(
                    labelText: 'Password (strong password)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderPlusValidators.strongPassword(),
                  ]),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.saveAndValidate() ?? false) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('All validations passed!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  },
                  child: const Text('Validate'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== Conditional Fields Demo ====================
class ConditionalFieldsDemo extends StatefulWidget {
  const ConditionalFieldsDemo({super.key});

  @override
  State<ConditionalFieldsDemo> createState() => _ConditionalFieldsDemoState();
}

class _ConditionalFieldsDemoState extends State<ConditionalFieldsDemo> {
  Map<String, dynamic> _formData = {}; // Store form data from FormBuilderPlus
  bool _hasAddress = false; // Track checkbox state separately
  String? _userType; // Track user type separately

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Conditional Fields',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Fields that show/hide based on other field values using ConditionalFormField.create()',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          Builder(
            builder: (context) {
              return FormBuilderPlus(
                onChanged: (formData) {
                  // Store the latest form data
                  setState(() {
                    _formData = formData;
                  });
                },
                child: Column(
                  children: [
                    FormBuilderDropdown<String>(
                      name: 'userType',
                      decoration: const InputDecoration(
                        labelText: 'User Type',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                      items: const [
                        DropdownMenuItem(
                            value: 'individual', child: Text('Individual')),
                        DropdownMenuItem(
                            value: 'business', child: Text('Business')),
                        DropdownMenuItem(
                            value: 'organization', child: Text('Organization')),
                      ],
                      onChanged: (value) {
                        // Update local state for conditional rendering
                        setState(() {
                          _userType = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    // Conditional field: Company Name (shows when userType is 'business')
                    if (_userType == 'business')
                      FormBuilderTextField(
                        name: 'companyName',
                        key: ValueKey(
                            'companyName_$_userType'), // Force rebuild when value changes
                        decoration: const InputDecoration(
                          labelText: 'Company Name',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.business),
                        ),
                      ),
                    // Conditional field: Organization Name (shows when userType is 'organization')
                    if (_userType == 'organization')
                      FormBuilderTextField(
                        name: 'organizationName',
                        key: ValueKey(
                            'organizationName_$_userType'), // Force rebuild when value changes
                        decoration: const InputDecoration(
                          labelText: 'Organization Name',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.corporate_fare),
                        ),
                      ),
                    const SizedBox(height: 16),
                    FormBuilderCheckbox(
                      name: 'hasAddress',
                      title: const Text('I have a shipping address'),
                      onChanged: (value) {
                        // Update local state for conditional rendering
                        setState(() {
                          _hasAddress = value ?? false;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    // Conditional field: Address (shows when hasAddress is true)
                    // Use the tracked _hasAddress state directly
                    if (_hasAddress)
                      FormBuilderTextField(
                        name: 'address',
                        key: ValueKey(
                            'address_$_hasAddress'), // Force rebuild when value changes
                        decoration: const InputDecoration(
                          labelText: 'Shipping Address',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.location_on),
                        ),
                        maxLines: 4,
                      ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: Builder(
                            builder: (buttonContext) {
                              return ElevatedButton(
                                onPressed: () {
                                  // Save the form first to ensure all values are captured
                                  buttonContext.saveForm();
                                  // Get form data directly from FormBuilderPlus using context extension
                                  final formData =
                                      buttonContext.formData ?? _formData;
                                  final hasAddressValue =
                                      formData['hasAddress'];
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Form data: $formData\n'
                                        'hasAddress: $hasAddressValue (${hasAddressValue.runtimeType})\n'
                                        'Equals true?: ${hasAddressValue == true}',
                                      ),
                                      backgroundColor: Colors.blue,
                                      duration: const Duration(seconds: 5),
                                    ),
                                  );
                                },
                                child: const Text('Show Form Data'),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ==================== Dynamic Form Demo ====================
class DynamicFormDemo extends StatefulWidget {
  const DynamicFormDemo({super.key});

  @override
  State<DynamicFormDemo> createState() => _DynamicFormDemoState();
}

class _DynamicFormDemoState extends State<DynamicFormDemo> {
  final _formData = <String, dynamic>{};

  @override
  Widget build(BuildContext context) {
    final config = {
      'name': 'user_registration',
      'fields': [
        {
          'name': 'username',
          'type': 'text',
          'label': 'Username',
          'required': true,
          'placeholder': 'Enter your username',
        },
        {
          'name': 'email',
          'type': 'email',
          'label': 'Email',
          'required': true,
          'placeholder': 'Enter your email',
        },
        {
          'name': 'age',
          'type': 'number',
          'label': 'Age',
          'required': true,
          'placeholder': 'Enter your age',
        },
        {
          'name': 'country',
          'type': 'dropdown',
          'label': 'Country',
          'options': {
            'choices': [
              'United States',
              'United Kingdom',
              'Canada',
              'Australia',
              'Germany'
            ],
          },
        },
        {
          'name': 'bio',
          'type': 'textarea',
          'label': 'Bio',
          'placeholder': 'Tell us about yourself',
          'options': {
            'maxLines': 4,
          },
        },
        {
          'name': 'agreeToTerms',
          'type': 'checkbox',
          'label': 'I agree to the terms and conditions',
          'required': true,
        },
      ],
      'options': {
        'autoValidate': false,
        'skipDisabled': true,
        'enabled': true,
      },
    };

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Dynamic Form Generation',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Forms generated from configuration objects. Supports all field types and conditional logic.',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          DynamicForm.create(
            config: config,
            formData: _formData,
            onFieldChanged: (name, value) {
              setState(() {
                _formData[name] = value;
              });
            },
            onFormSubmitted: (data) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Form submitted: $data'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            onFormReset: () {
              setState(() {
                _formData.clear();
              });
            },
          ),
        ],
      ),
    );
  }
}

// ==================== All Field Types Demo ====================
class AllFieldTypesDemo extends StatefulWidget {
  const AllFieldTypesDemo({super.key});

  @override
  State<AllFieldTypesDemo> createState() => _AllFieldTypesDemoState();
}

class _AllFieldTypesDemoState extends State<AllFieldTypesDemo> {
  final _formData = <String, dynamic>{};

  @override
  Widget build(BuildContext context) {
    final config = {
      'name': 'all_field_types',
      'fields': [
        {
          'name': 'textField',
          'type': 'text',
          'label': 'Text Field',
          'placeholder': 'Enter text',
          'required': true,
        },
        {
          'name': 'emailField',
          'type': 'email',
          'label': 'Email Field',
          'placeholder': 'Enter email',
          'required': true,
        },
        {
          'name': 'passwordField',
          'type': 'password',
          'label': 'Password Field',
          'placeholder': 'Enter password',
          'required': true,
        },
        {
          'name': 'numberField',
          'type': 'number',
          'label': 'Number Field',
          'placeholder': 'Enter number',
          'required': true,
        },
        {
          'name': 'textareaField',
          'type': 'textarea',
          'label': 'Textarea Field',
          'placeholder': 'Enter multi-line text',
          'options': {
            'maxLines': 5,
          },
        },
        {
          'name': 'checkboxField',
          'type': 'checkbox',
          'label': 'Checkbox Field',
        },
        {
          'name': 'radioField',
          'type': 'radio',
          'label': 'Radio Field',
          'options': {
            'choices': ['Option 1', 'Option 2', 'Option 3'],
          },
        },
        {
          'name': 'dropdownField',
          'type': 'dropdown',
          'label': 'Dropdown Field',
          'options': {
            'choices': ['Choice 1', 'Choice 2', 'Choice 3', 'Choice 4'],
          },
        },
      ],
      'options': {
        'autoValidate': false,
        'enabled': true,
      },
    };

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'All Field Types',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Demonstrates all supported field types: text, email, password, number, textarea, checkbox, radio, dropdown',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          DynamicForm.create(
            config: config,
            formData: _formData,
            onFieldChanged: (name, value) {
              setState(() {
                _formData[name] = value;
              });
            },
            onFormSubmitted: (data) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('All field types demo submitted: $data'),
                  backgroundColor: Colors.green,
                  duration: const Duration(seconds: 3),
                ),
              );
            },
            onFormReset: () {
              setState(() {
                _formData.clear();
              });
            },
          ),
        ],
      ),
    );
  }
}

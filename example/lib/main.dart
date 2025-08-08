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
      title: 'Flutter Form Builder Plus Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Form Builder Plus Example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();
  final _formData = <String, dynamic>{};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Basic Form Example',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            FormBuilder(
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
                  const SizedBox(height: 16),
                  FormBuilderCheckbox(
                    name: 'subscribe',
                    title: const Text('Subscribe to newsletter'),
                    onChanged: (value) {
                      setState(() {
                        _formData['subscribe'] = value;
                      });
                    },
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _submitForm,
                          child: const Text('Submit'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _resetForm,
                          child: const Text('Reset'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Dynamic Form Example',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildDynamicFormExample(),
            const SizedBox(height: 32),
            const Text(
              'Conditional Form Example',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildConditionalFormExample(),
          ],
        ),
      ),
    );
  }

  Widget _buildDynamicFormExample() {
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

    return DynamicForm.create(
      config: config,
      formData: _formData,
      onFieldChanged: (name, value) {
        setState(() {
          _formData[name] = value;
        });
      },
      onFormSubmitted: (data) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Form submitted: $data')),
        );
      },
    );
  }

  Widget _buildConditionalFormExample() {
    return FormBuilder(
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
          if (_formData['userType'] == 'business')
            FormBuilderTextField(
              name: 'companyName',
              decoration: const InputDecoration(
                labelText: 'Company Name',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _formData['companyName'] = value;
                });
              },
            ),
        ],
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Form submitted: $_formData')),
      );
    }
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    setState(() {
      _formData.clear();
    });
  }
}

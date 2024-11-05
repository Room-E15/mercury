import 'package:flutter/material.dart';
import 'verification_view.dart';
import 'package:http/http.dart' as http;

import '../services/globals.dart';

class StartView extends StatefulWidget {
  static const routeName = '/start';

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController areaCodeController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  final Widget logo;

  StartView({super.key, required this.logo});

  @override
  StartViewState createState() => StartViewState();
}

class StartViewState extends State<StartView> {
  final formKey = GlobalKey<FormState>();

  String? selectedValue = "+1"; // Current selected value

  final List<String> options = ['+1', '+2', '+3']; // Options list

  Future<void> _submitForm() async {
    // Validate returns true if the form is valid, or false otherwise.
    if (formKey.currentState!.validate()) {
      // If the form is valid, display a snackbar. In the real world,
      // you'd often call a server or save the information in a database.
      final firstName = widget.firstNameController.text;
      final lastName = widget.lastNameController.text;
      final areaCode = widget.areaCodeController.text;
      final phoneNumber = widget.phoneNumberController.text;

      // Prepare the data for the HTTP request
      final uri = Uri.parse('$baseURL/add');
      final response = await http.post(
        uri,
        body: {
          'firstName': firstName,
          'lastName': lastName,
          'areaCode': areaCode,
          'phoneNumber': phoneNumber,
        },
      );

      // Handle response
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Form submitted successfully!')),
        );
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VerificationView(
                logo: widget.logo,
                firstName: widget.firstNameController.text,
                lastName: widget.lastNameController.text,
                phoneNumber: widget.phoneNumberController.text,
              ),
            ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit form')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.logo,
      ),
      body: Column(
        children: [
          const Padding(
              padding: EdgeInsets.all(40),
              child: Text("Welcome! Please enter your information.")),
          Form(
            key: formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    controller: widget.firstNameController,
                    decoration: const InputDecoration(
                      labelText: 'First Name',
                    ),
                    validator: (value) {
                      if (value == null) {
                        return 'Please enter some text';
                      } else if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
                        return 'Please only use only alphabetical characters';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    controller: widget.lastNameController,
                    decoration: const InputDecoration(
                      labelText: 'Last Name',
                    ),
                    validator: (value) {
                      if (value == null) {
                        return 'Please enter some text';
                      } else if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
                        return 'Please only use only alphabetical characters';
                      }
                      return null;
                    },
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: DropdownButtonFormField<String>(
                          value: selectedValue, // Currently selected value
                          items: options.map((String option) {
                            return DropdownMenuItem<String>(
                              value: option,
                              child: Text(option),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setState(() {
                                selectedValue = newValue;
                              });
                            }
                          },
                          decoration: const InputDecoration(
                            labelText: 'Area Code',
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextFormField(
                          controller: widget.phoneNumberController,
                          decoration: const InputDecoration(
                            labelText: 'Phone Number',
                          ),
                          validator: (value) {
                            if (value == null) {
                              return 'Please enter some text';
                            } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                              return 'Please only use only numerical characters';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    child: const Text('Submit'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

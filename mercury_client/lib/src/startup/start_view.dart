import 'package:flutter/material.dart';
import 'package:mercury_client/src/utils/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'verification_view.dart';
import 'package:http/http.dart' as http;

import '../services/globals.dart';

class StartView extends StatelessWidget {
  static const routeName = '/start';

  final _formKey = GlobalKey<FormState>();  // Replaced Global Key
  final countryCodeController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final phoneCarrierController = TextEditingController();

  final selectedCode = "+1"; // Current selected value
  final countryCodeOptions = [
    '+1',
    '+2',
    '+3'
  ]; // Options list  TODO get from somewhere
  final phoneCarrierOptions = [
    'AT&T',
    'Verizon',
    'T-Mobile'
  ]; // Options list, TODO get from server

  final SharedPreferencesWithCache preferences;

  StartView({super.key, required this.preferences});

  // TODO move to server calls file
  Future<void> _submitForm() async {
    // Validate returns true if the form is valid, or false otherwise.
    if (formKey.currentState!.validate()) {
      // Update countryCodeController with the selected value explicitly
      widget.countryCodeController.text = selectedValue!;

      final firstName = widget.firstNameController.text;
      final lastName = widget.lastNameController.text;
      final countryCode = widget.countryCodeController.text;
      final phoneNumber = widget.phoneNumberController.text;

      // Prepare the data for the HTTP request
      final uri = Uri.parse('$baseURL/add');
      final response = await http.post(
        uri,
        body: {
          'firstName': firstName,
          'lastName': lastName,
          'countryCode': countryCode,
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
  void initState() {
    super.initState();
    selectedValue = widget.countryCodeController.text.isNotEmpty
        ? widget.countryCodeController.text
        : options.first; // Default to first option if no initial value
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appLogo,
      ),
      body: Column(
        children: [
          const Padding(
              padding: EdgeInsets.all(40),
              child: Text("Welcome! Please enter your phone information.")),
          Form(
            key: _formKey,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: DropdownButtonFormField<String>(
                          value: selectedCode, // Currently selected value
                          items: countryCodeOptions.map((String option) {
                            return DropdownMenuItem<String>(
                              value: option,
                              child: Text(option),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setState(() {
                                selectedValue = newValue;
                                widget.countryCodeController.text =
                                    newValue; // Save to controller
                              });
                            }
                          },
                          decoration: const InputDecoration(
                            labelText: 'Country Code',
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextFormField(
                          controller: phoneNumberController,
                          decoration: const InputDecoration(
                            labelText: 'Phone Number',
                          ),
                          validator: (value) {
                            if (value == null || value == '') {
                              return 'Please enter your 10 digit phone number';
                            } else if (!RegExp(r'^[0-9]{10}$')
                                .hasMatch(value)) {
                              return 'Please enter 10 numerical characters';
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
                  child: DropdownButtonFormField<String>(
                    items: phoneCarrierOptions.map((String option) {
                      return DropdownMenuItem<String>(
                        value: option,
                        child: Text(option),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {},
                    decoration: const InputDecoration(
                      labelText: 'Network Carrier',
                    ),
                    validator: (value) {
                      if (value == null) {
                        return 'Please select your network carrier';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      // Validate returns true if the form is valid, or false otherwise.
                      if (_formKey.currentState!.validate()) {
                        // If the form is valid, display a snackbar. In the real world,
                        // you'd often call a server or save the information in a database.
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VerificationView(
                                preferences: preferences,
                                countryCode: countryCodeController.text,
                                phoneNumber: phoneNumberController.text,
                                carrier: phoneCarrierController.text,
                              ),
                            ));
                       
                      }
                    },
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

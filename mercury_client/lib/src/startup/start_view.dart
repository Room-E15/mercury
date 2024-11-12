import 'package:flutter/material.dart';
import 'package:mercury_client/src/utils/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'verification_view.dart';


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
                          onChanged: (String? newValue) {},
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
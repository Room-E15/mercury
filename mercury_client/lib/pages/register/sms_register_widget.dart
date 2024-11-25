import 'package:flutter/material.dart';
import 'package:mercury_client/models/data/carrier.dart';
import 'package:mercury_client/models/requests/verification_requests.dart';
import 'package:mercury_client/widgets/loading_icon.dart';

class SmsRegisterWidget extends StatefulWidget {
  final List<Carrier> carriers;
  final List<int> countryCodes;
  final Function onSubmit;

  const SmsRegisterWidget(
      {super.key,
      required this.carriers,
      required this.countryCodes,
      required this.onSubmit});

  @override
  State<StatefulWidget> createState() => _SmsRegisterWidgetState();
}

class _SmsRegisterWidgetState extends State<SmsRegisterWidget> {
  final _formKey = GlobalKey<FormState>(); // Replaced Global Key
  LoadingState _loadingIconState = LoadingState.nothing;

  int _countryCode = 1;
  String _phoneNumber = "";
  String _phoneCarrier = "";

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: DropdownButtonFormField<int>(
                    value: _countryCode, // Currently selected value
                    items: widget.countryCodes.map((int option) {
                      return DropdownMenuItem<int>(
                        value: option,
                        child: Text("+$option"),
                      );
                    }).toList(),
                    onChanged: (int? newValue) {
                      _countryCode = newValue!;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Country',
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                    ),
                    validator: (value) {
                      if (value == null || value == '') {
                        return 'Please enter your 10 digit phone number';
                      } else if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                        return 'Please enter 10 numerical characters';
                      }
                      return null;
                    },
                    onChanged: (value) => _phoneNumber = value,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DropdownButtonFormField<String>(
              items: widget.carriers.map((Carrier option) {
                return DropdownMenuItem<String>(
                  value: option.id,
                  child: Text(option.name),
                );
              }).toList(),
              onChanged: (String? newValue) {
                _phoneCarrier = newValue!;
              },
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
              onPressed: _loadingIconState == LoadingState.loading ||
                      _loadingIconState == LoadingState.success
                  ? null
                  : () {
                      setState(() {
                        _loadingIconState = LoadingState.loading;
                      });
                      widget.onSubmit(
                          context,
                          VerificationRequests.requestDispatch(
                                  _countryCode, _phoneNumber, _phoneCarrier)
                              .onError((_, __) {
                            setState(
                                () => _loadingIconState = LoadingState.failure);
                            return null;
                          }).then((response) {
                            setState(
                                () => _loadingIconState = LoadingState.success);
                            return Future.delayed(const Duration(seconds: 2),
                                () {
                              setState(() {
                                _loadingIconState = LoadingState.nothing;
                              });
                              return response;
                            });
                          }));
                    },
              child: const Text('Submit'),
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(16.0),
              child: LoadingIcon(state: _loadingIconState, errorMessage: 'Could not send SMS')),
        ],
      ),
    );
  }
}

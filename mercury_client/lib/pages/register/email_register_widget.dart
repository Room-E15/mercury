import 'package:flutter/material.dart';
import 'package:mercury_client/models/requests/verification_requests.dart';
import 'package:mercury_client/widgets/loading_icon.dart';

class EmailRegisterWidget extends StatefulWidget {
  final Function onSubmit;

  const EmailRegisterWidget({super.key, required this.onSubmit});

  @override
  State<StatefulWidget> createState() => _EmailRegisterWidgetState();
}

class _EmailRegisterWidgetState extends State<EmailRegisterWidget> {
  final _formKey = GlobalKey<FormState>(); // Replaced Global Key
  LoadingState _loadingIconState = LoadingState.nothing;
  String _emailAddress = "";

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'E-mail Address',
                    ),
                    validator: (value) {
                      if (value == null || value == '') {
                        return 'Please enter your email address';
                      } else if (!RegExp(r'/^\S+@\S+\.\S+$/').hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                    onChanged: (value) => _emailAddress = value,
                  ),
                ),
              ),
            ],
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
                                  -1, _emailAddress, "e-mail")
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
              child: LoadingIcon(state: _loadingIconState, errorMessage: 'Could not send e-mail message')),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:mercury_client/models/requests/verification_requests.dart';
import 'package:mercury_client/pages/register/verification_view.dart';

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

  Widget displayLoadingIcon(LoadingState state) {
    // TODO add nice animations for check (slowly fills in) and X (shakes widget)
    switch (state) {
      case LoadingState.nothing:
        return Container();
      case LoadingState.loading:
        return const CircularProgressIndicator();
      case LoadingState.success:
        return const Icon(Icons.check);
      case LoadingState.failure:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.close),
            Text('Invalid Verification Code'),
          ],
        );
    }
  }

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
              onPressed: _loadingIconState == LoadingState.loading
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
                            return response;
                          }));
                    },
              child: const Text('Submit'),
            ),
          ),
          Padding(
                padding: const EdgeInsets.all(16.0),
                child: displayLoadingIcon(_loadingIconState)),
        ],
      ),
    );
  }
}

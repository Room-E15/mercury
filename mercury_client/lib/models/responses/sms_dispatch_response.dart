import 'dart:developer';

class SMSDispatchResponse {
  final bool carrierFound;
  final String token;

  SMSDispatchResponse({
    required this.carrierFound,
    this.token = "",
  });

  factory SMSDispatchResponse.fromJson(Map json) {
    log('json: $json');
    if (json
        case {
          'carrierFound': bool _,
          'token': String token,
        }) {
      return SMSDispatchResponse(carrierFound: true, token: token);
    } else {
      log('SMSDispatchResponse.fromJson: Failed to parse SMSDispatchResponse from JSON: $json');
      return SMSDispatchResponse(carrierFound: false);
    }
  }
}

class SMSDispatchResponse {
  final bool carrierFound;
  final String token;

  SMSDispatchResponse({
    required this.carrierFound,
    this.token = "",
  });

  SMSDispatchResponse.fromJson(Map json)
      : carrierFound = json['carrierFound'],
        token = json['token'];
}

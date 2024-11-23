import 'dart:convert';

import 'package:mercury_client/models/data/carrier.dart';

class CarrierListResponse {
  List<(String, String, List<Carrier>)> carrierTypes = [];

  CarrierListResponse({
    required this.carrierTypes,
  });

  CarrierListResponse.fromJson(String json) {
    jsonDecode(json).forEach((value) {
      if (value != null && value is Map) {
        carrierTypes.add(
          (value['type'], 
            value['displayName'], 
            Carrier.listFromJson(value['carriers'])
          )
        );
      }
      return value;
      }
    );
  }
}

import 'dart:developer';
import 'package:mercury_client/models/data/carrier.dart';

class CarrierTabList {
  final List<String> types;
  final List<String> names;
  final List<List<Carrier>> carrierLists;

  const CarrierTabList({
    required this.types,
    required this.names,
    required this.carrierLists,
  });

  void forEach(Function(String, String, List<Carrier>) callback) {
    for (int i = 0; i < types.length; i++) {
      callback(types[i], names[i], carrierLists[i]);
    }
  }

  // Factory constructor to create a Group instance from JSON
  factory CarrierTabList.fromJson(List<Map<String, dynamic>> data) {
    List<String> types = [];
    List<String> names = [];
    List<List<Carrier>> carrierLists = [];

    log('[CarrierTabList.fromJson] $data');
    
    for(Map<String, dynamic> element in data) {
      if (element
          case {
            'displayName': String displayName,
            'carriers': List<dynamic> carriers,
            'type': String type,
          }) {

        names.add(displayName);
        types.add(type);

        List<Carrier> carrierList = [];
        for (final carrier in carriers) {
          if (carrier
              case {
                'id': String id,
                'name': String name,
              }) {
            carrierList.add(Carrier(
              id: id,
              name: name,
            ));
          }
        }
        carrierLists.add(carrierList);
      } else {
        throw Exception(
            'CarrierTabList.fromJson: Failed to parse CarrierTabList from JSON: $data');
      }
    }
      
    return CarrierTabList(types: types, names: names, carrierLists: carrierLists);
  }
}

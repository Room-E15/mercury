import 'dart:developer';

import 'package:mercury_client/models/data/group.dart';

class User {
  final String firstName;
  final String lastName;
  final int countryCode;
  final String phoneNumber;
  final GroupResponse? response;

  User({
    required this.firstName,
    required this.lastName,
    required this.countryCode,
    required this.phoneNumber,
    this.response,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    if (json
        case {
          'firstName': String firstName,
          'lastName': String lastName,
          'countryCode': int countryCode,
          'phoneNumber': String phoneNumber,
        }) {
      dynamic id = json['id'];

      // unwrap the response object
      final jsonResponse = json['response'] as Map<String, dynamic>?;
      // parse the response object's data
      final response =
          (jsonResponse == null) ? null : GroupResponse.fromJson(jsonResponse);

      if (id is String) {
        return RegisteredUser(
          id: id,
          firstName: firstName,
          lastName: lastName,
          countryCode: countryCode,
          phoneNumber: phoneNumber,
          response: response,
        );
      }
      return User(
        firstName: firstName,
        lastName: lastName,
        countryCode: countryCode,
        phoneNumber: phoneNumber,
        response: response,
      );
    } else {
      throw Exception('User.fromJson: Failed to parse User from JSON: $json');
    }
  }
}

class RegisteredUser extends User {
  final String id;

  RegisteredUser({
    required this.id,
    required super.firstName,
    required super.lastName,
    required super.countryCode,
    required super.phoneNumber,
    super.response,
  });

  RegisteredUser.fromUser(User user, this.id)
      : super(
          firstName: user.firstName,
          lastName: user.lastName,
          countryCode: user.countryCode,
          phoneNumber: user.phoneNumber,
        );

  // Factory constructor to create a Group instance from JSON
  factory RegisteredUser.fromJson(Map<String, dynamic> data) {
    log('[RegisteredUser.fromJson] $data');
    if (data
        case {
          'id': String id,
          'firstName': String firstName,
          'lastName': String lastName,
          'countryCode': int countryCode,
          'phoneNumber': String phoneNumber,
        }) {
      // unwrap the response object
      final jsonResponse = data['response'] as Map<String, dynamic>?;
      // parse the response object's data
      final response =
          (jsonResponse == null) ? null : GroupResponse.fromJson(jsonResponse);
      // return the new member, with or without a response
      return RegisteredUser(
        id: id,
        firstName: firstName,
        lastName: lastName,
        countryCode: countryCode,
        phoneNumber: phoneNumber,
        response: response,
      );
    } else {
      throw Exception(
          'RegisteredUser.fromJson: Failed to parse Member from JSON: $data');
    }
  }
}

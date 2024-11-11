import 'dart:convert';

import 'package:http/http.dart' as http;
import '../models/member.dart';

import 'globals.dart';

class DatabaseServices {
  static Future<Member> addMember(String firstName, String lastName,
      String countryCode, String phoneNumber) async {
    Map data = {
      "firstName": firstName,
      "lastName": lastName,
      "countryCode": countryCode,
      "phoneNumber": phoneNumber,
    };
    var body = json.encode(data);
    var url = Uri.parse('$baseURL/add');

    http.Response response = await http.post(
      url,
      headers: headers,
      body: body,
    );
    Map responseMap = jsonDecode(response.body);
    Member member = Member.fromMap(responseMap);

    return member;
  }

  static Future<List<Member>> getMembers() async {
    var url = Uri.parse(baseURL);
    http.Response response = await http.get(
      url,
      headers: headers,
    );
    List responseList = jsonDecode(response.body);
    List<Member> members = [];
    for (Map memberMap in responseList) {
      Member member = Member.fromMap(memberMap);
      members.add(member);
    }
    return members;
  }
}

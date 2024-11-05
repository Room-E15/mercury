import 'package:flutter/material.dart';

import 'member.dart';
import '../services/database_services.dart';

class MemberData extends ChangeNotifier{
  List<Member> members = [];

  void addMember(String firstName, String lastName, String areaCode, String phoneNumber) async {
    Member member = await DatabaseServices.addMember(firstName, lastName, areaCode, phoneNumber);
    members.add(member);
    notifyListeners();
  }
}
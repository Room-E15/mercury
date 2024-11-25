import 'dart:developer';

import 'package:mercury_client/models/data/alert.dart';
import 'package:mercury_client/models/data/user.dart';

class Group {
  final String id;
  final String name;
  final List<User> members;
  final List<User> leaders;
  final bool isLeader;
  final Alert? latestAlert;

  late int memberCount;
  late int responseCount;
  late List<User> unsafeMembers = [];
  late List<User> safeMembers = [];
  late List<User> noResponseMembers = [];

  Group({
    required this.id,
    required this.name,
    required this.isLeader,
    required this.latestAlert,
    required this.members,
    required this.leaders,
  }) {
    memberCount = members.length + leaders.length;

    // figure out if anyone is unsafe
    for (final member in members + leaders) {
      switch (member.response?.safe) {
        case true:
          safeMembers.add(member);
          break;
        case false:
          unsafeMembers.add(member);
          break;
        default:
          noResponseMembers.add(member);
          break;
      }
    }

    responseCount = safeMembers.length + unsafeMembers.length;
  }

  // Factory constructor to create a Group instance from JSON
  factory Group.fromJson(Map<String, dynamic> data) {
    log('[Group.fromJson] $data');
    if (data
        case {
          'id': String id,
          'name': String name,
          'isLeader': bool isLeader,
          'members': List<dynamic> jsonMembers,
          'leaders': List<dynamic> jsonLeaders,
        }) {
      Alert? latestAlert;
      if (data.containsKey('latestAlert') &&
          data['latestAlert'] is Map<String, dynamic>) {
        latestAlert =
            Alert.fromJson(data['latestAlert'] as Map<String, dynamic>);
      } else {
        latestAlert = null;
      }

      List<User> members = jsonMembers.map((json) {
        if (json is Map<String, dynamic>) {
          return User.fromJson(json);
        } else {
          throw Exception(
              'Group.fromJson: Failed to parse Group from JSON: $json');
        }
      }).toList();

      List<User> leaders = jsonLeaders.map((json) {
        if (json is Map<String, dynamic>) {
          return User.fromJson(json);
        } else {
          throw Exception(
              'Group.fromJson: Failed to parse Group from JSON: $json');
        }
      }).toList();

      return Group(
          id: id,
          name: name,
          isLeader: isLeader,
          latestAlert: latestAlert,
          members: members,
          leaders: leaders);
    } else {
      throw Exception('Group.fromJson: Failed to parse Group from JSON: $data');
    }
  }
}

class GroupResponse {
  const GroupResponse(this.safe, this.battery, this.latitude, this.longitude);

  final bool safe;
  final int battery;
  final double latitude;
  final double longitude;

  // Factory constructor to create a GroupResponse instance from JSON
  factory GroupResponse.fromJson(Map<String, dynamic> data) {
    log('[GroupResponse.fromJson] $data');
    if (data
        case {
          'isSafe': bool safe,
          'battery': int battery,
          'latitude': double latitude,
          'longitude': double longitude,
        }) {
      return GroupResponse(safe, battery, latitude, longitude);
    } else {
      throw Exception(
          'GroupResponse.fromJson: Failed to parse GroupResponse from JSON: $data');
    }
  }
}

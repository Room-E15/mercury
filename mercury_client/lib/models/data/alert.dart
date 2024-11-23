class Alert {
  final String id;
  final String groupId;
  final String title;
  final String description;

  const Alert({
    required this.id,
    required this.groupId,
    required this.title,
    required this.description,
  });

  factory Alert.fromJson(Map<String, dynamic> data) {
    if (data
        case {
          'id': String id,
          'groupId': String groupId,
          'title': String title,
          'description': String description,
        }) {
      return Alert(
          id: id, groupId: groupId, title: title, description: description);
    } else {
      throw Exception('Alert.fromJson: Failed to parse Alert from JSON: $data');
    }
  }
}

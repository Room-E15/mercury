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

  factory Alert.fromJson(dynamic json) {
    return Alert(
      id: json['id'],
      groupId: json['groupId'],
      title: json['title'],
      description: json['description'],
    );
  }
}

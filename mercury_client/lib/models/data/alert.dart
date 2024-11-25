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

  @override
  bool operator ==(Object other) =>
      other is Alert &&
      id == other.id &&
      groupId == other.groupId &&
      title == other.title &&
      description == other.description;

  @override
  int get hashCode => Object.hash(id, groupId, title, description);

  factory Alert.fromJson(dynamic json) {
    return Alert(
      id: json['id'],
      groupId: json['groupId'],
      title: json['title'],
      description: json['description'],
    );
  }
}

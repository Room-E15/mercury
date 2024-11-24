class Carrier {
  final String id;
  final String name;

  const Carrier({
    required this.id,
    required this.name,
  });

  factory Carrier.fromJson(dynamic json) {
    return Carrier(
      id: json['id'],
      name: json['name'],
    );
  }

  static List<Carrier> listFromJson(List<dynamic> json) {
    return json.map((value) => Carrier.fromJson(value)).toList();
  }
}

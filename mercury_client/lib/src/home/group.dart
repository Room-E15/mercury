class Group {
  const Group(
      this.id, this.name, this.memberCount, this.responseCount, this.unsafe);

  final int id;
  final String name;
  final int memberCount;
  final int responseCount;
  final int unsafe;
  // final List<Response> responses = List<Response>.empty();
}

class Response {
  const Response(this.safe, this.battery, this.latitude, this.longitude);

  final bool safe;
  final int battery;
  final double latitude;
  final double longitude;
}

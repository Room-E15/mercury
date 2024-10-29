class Alert{
  const Alert(this.name, this.description);

  final String name;
  final String description;
}

class AlertTestData {
  static const List<Alert> alerts = [
    Alert("Flood in Milan", "Flooding has been identified in Milan"),
    Alert("Protest in Florence", "A climate protest is ongoing in Florence"),
    Alert("Earthquake in Venice", "A 6.2 earthquake has been detected in Venice")
  ];
}
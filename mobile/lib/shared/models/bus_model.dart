enum BusServiceType {
  sarige,
  karnatakaSarige,
  kalyanaRatha,
  vaibhava,
  rajahamsa,
  express,
  nonStop;

  String get label {
    switch (this) {
      case BusServiceType.sarige:
        return 'Karnataka Sarige';
      case BusServiceType.karnatakaSarige:
        return 'Karnataka Sarige (Ordinary)';
      case BusServiceType.kalyanaRatha:
        return 'Kalyana Ratha (AC Sleeper)';
      case BusServiceType.vaibhava:
        return 'Karnataka Vaibhava (Non-AC Express)';
      case BusServiceType.rajahamsa:
        return 'Rajahamsa Executive';
      case BusServiceType.express:
        return 'Express';
      case BusServiceType.nonStop:
        return 'Point-to-Point Non-Stop';
    }
  }
}

class BusModel {
  final String id;
  final String registrationNumber; // e.g., KA-34-F-1204
  final String depotName; // e.g., Ballari Central Depot
  final BusServiceType serviceType;
  final int capacity;
  final String modelName;

  const BusModel({
    required this.id,
    required this.registrationNumber,
    required this.depotName,
    required this.serviceType,
    this.capacity = 54,
    this.modelName = 'Tata LPO 1618 Sarige',
  });

  String get serviceTypeDisplayName => serviceType.label;
}

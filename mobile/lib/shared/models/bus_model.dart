enum BusServiceType { sarige, kalyanaRatha, vaibhava, rajahamsa, nonStop }

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

  String get serviceTypeDisplayName {
    switch (serviceType) {
      case BusServiceType.sarige:
        return 'Karnataka Sarige (Ordinary)';
      case BusServiceType.kalyanaRatha:
        return 'Kalyana Ratha (AC Sleeper)';
      case BusServiceType.vaibhava:
        return 'Karnataka Vaibhava (Non-AC Express)';
      case BusServiceType.rajahamsa:
        return 'Rajahamsa Executive';
      case BusServiceType.nonStop:
        return 'Point-to-Point Non-Stop';
    }
  }
}

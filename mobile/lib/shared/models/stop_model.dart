class StopModel {
  final String id;
  final String nameEn;
  final String nameKn;
  final int sequence;
  final double latitude;
  final double longitude;
  final String? landmark;

  const StopModel({
    required this.id,
    required this.nameEn,
    required this.nameKn,
    required this.sequence,
    required this.latitude,
    required this.longitude,
    this.landmark,
  });

  String get localizedName => '$nameEn ($nameKn)';
}

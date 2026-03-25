class Vehicle {
  final String id;
  final String name;
  final String plateNumber;
  final int currentKm;
  final DateTime createdAt;

  Vehicle({
    required this.id,
    required this.name,
    required this.plateNumber,
    required this.currentKm,
    required this.createdAt,
  });

  Vehicle copyWith({
    String? id,
    String? name,
    String? plateNumber,
    int? currentKm,
    DateTime? createdAt,
  }) {
    return Vehicle(
      id: id ?? this.id,
      name: name ?? this.name,
      plateNumber: plateNumber ?? this.plateNumber,
      currentKm: currentKm ?? this.currentKm,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

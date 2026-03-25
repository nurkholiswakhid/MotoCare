import '../../core/entities/vehicle.dart';

class VehicleModel extends Vehicle {
  VehicleModel({
    required super.id,
    required super.name,
    required super.plateNumber,
    required super.currentKm,
    required super.createdAt,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      id: json['id'] as String,
      name: json['name'] as String,
      plateNumber: json['plateNumber'] as String,
      currentKm: json['currentKm'] as int,
      createdAt: (json['createdAt'] as String) != ''
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
    );
  }

  factory VehicleModel.fromEntity(Vehicle vehicle) {
    return VehicleModel(
      id: vehicle.id,
      name: vehicle.name,
      plateNumber: vehicle.plateNumber,
      currentKm: vehicle.currentKm,
      createdAt: vehicle.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'plateNumber': plateNumber,
      'currentKm': currentKm,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  VehicleModel copyWith({
    String? id,
    String? name,
    String? plateNumber,
    int? currentKm,
    DateTime? createdAt,
  }) {
    return VehicleModel(
      id: id ?? this.id,
      name: name ?? this.name,
      plateNumber: plateNumber ?? this.plateNumber,
      currentKm: currentKm ?? this.currentKm,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

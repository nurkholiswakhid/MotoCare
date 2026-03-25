import '../../core/entities/schedule.dart';
import '../../core/entities/service_history.dart';

class ServiceHistoryModel extends ServiceHistory {
  ServiceHistoryModel({
    required super.id,
    required super.vehicleId,
    required super.type,
    required super.date,
    required super.costInRupiah,
    required super.notes,
  });

  factory ServiceHistoryModel.fromJson(Map<String, dynamic> json) {
    return ServiceHistoryModel(
      id: json['id'] as String,
      vehicleId: json['vehicleId'] as String,
      type: ServiceType.values.firstWhere(
        (e) => e.toString() == 'ServiceType.${json['type']}',
        orElse: () => ServiceType.servisRutin,
      ),
      date: DateTime.parse(json['date'] as String),
      costInRupiah: json['costInRupiah'] as int? ?? 0,
      notes: json['notes'] as String? ?? '',
    );
  }

  factory ServiceHistoryModel.fromEntity(ServiceHistory history) {
    return ServiceHistoryModel(
      id: history.id,
      vehicleId: history.vehicleId,
      type: history.type,
      date: history.date,
      costInRupiah: history.costInRupiah,
      notes: history.notes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vehicleId': vehicleId,
      'type': type.toString().split('.').last,
      'date': date.toIso8601String(),
      'costInRupiah': costInRupiah,
      'notes': notes,
    };
  }

  ServiceHistoryModel copyWith({
    String? id,
    String? vehicleId,
    ServiceType? type,
    DateTime? date,
    int? costInRupiah,
    String? notes,
  }) {
    return ServiceHistoryModel(
      id: id ?? this.id,
      vehicleId: vehicleId ?? this.vehicleId,
      type: type ?? this.type,
      date: date ?? this.date,
      costInRupiah: costInRupiah ?? this.costInRupiah,
      notes: notes ?? this.notes,
    );
  }
}

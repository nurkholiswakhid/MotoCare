import 'schedule.dart';

class ServiceHistory {
  final String id;
  final String vehicleId;
  final ServiceType type;
  final DateTime date;
  final int costInRupiah;
  final String notes;

  ServiceHistory({
    required this.id,
    required this.vehicleId,
    required this.type,
    required this.date,
    required this.costInRupiah,
    required this.notes,
  });

  ServiceHistory copyWith({
    String? id,
    String? vehicleId,
    ServiceType? type,
    DateTime? date,
    int? costInRupiah,
    String? notes,
  }) {
    return ServiceHistory(
      id: id ?? this.id,
      vehicleId: vehicleId ?? this.vehicleId,
      type: type ?? this.type,
      date: date ?? this.date,
      costInRupiah: costInRupiah ?? this.costInRupiah,
      notes: notes ?? this.notes,
    );
  }
}

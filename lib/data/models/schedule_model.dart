import '../../core/entities/schedule.dart';

class ScheduleModel extends Schedule {
  ScheduleModel({
    required super.id,
    required super.vehicleId,
    required super.type,
    required super.lastServiceDate,
    super.intervalDays,
    super.intervalKm,
    required super.nextDueDate,
    required super.lastServiceKm,
  });

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    return ScheduleModel(
      id: json['id'] as String,
      vehicleId: json['vehicleId'] as String,
      type: ServiceType.values.firstWhere(
        (e) => e.toString() == 'ServiceType.${json['type']}',
        orElse: () => ServiceType.servisRutin,
      ),
      lastServiceDate: DateTime.parse(json['lastServiceDate'] as String),
      intervalDays: json['intervalDays'] as int?,
      intervalKm: json['intervalKm'] as int?,
      nextDueDate: DateTime.parse(json['nextDueDate'] as String),
      lastServiceKm: json['lastServiceKm'] as int,
    );
  }

  factory ScheduleModel.fromEntity(Schedule schedule) {
    return ScheduleModel(
      id: schedule.id,
      vehicleId: schedule.vehicleId,
      type: schedule.type,
      lastServiceDate: schedule.lastServiceDate,
      intervalDays: schedule.intervalDays,
      intervalKm: schedule.intervalKm,
      nextDueDate: schedule.nextDueDate,
      lastServiceKm: schedule.lastServiceKm,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vehicleId': vehicleId,
      'type': type.toString().split('.').last,
      'lastServiceDate': lastServiceDate.toIso8601String(),
      'intervalDays': intervalDays,
      'intervalKm': intervalKm,
      'nextDueDate': nextDueDate.toIso8601String(),
      'lastServiceKm': lastServiceKm,
    };
  }

  ScheduleModel copyWith({
    String? id,
    String? vehicleId,
    ServiceType? type,
    DateTime? lastServiceDate,
    int? intervalDays,
    int? intervalKm,
    DateTime? nextDueDate,
    int? lastServiceKm,
  }) {
    return ScheduleModel(
      id: id ?? this.id,
      vehicleId: vehicleId ?? this.vehicleId,
      type: type ?? this.type,
      lastServiceDate: lastServiceDate ?? this.lastServiceDate,
      intervalDays: intervalDays ?? this.intervalDays,
      intervalKm: intervalKm ?? this.intervalKm,
      nextDueDate: nextDueDate ?? this.nextDueDate,
      lastServiceKm: lastServiceKm ?? this.lastServiceKm,
    );
  }
}

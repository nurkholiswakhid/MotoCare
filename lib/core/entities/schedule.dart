enum ServiceType { gantiOli, servisRutin }

class Schedule {
  final String id;
  final String vehicleId;
  final ServiceType type;
  final DateTime lastServiceDate;
  final int? intervalDays;
  final int? intervalKm;
  final DateTime nextDueDate;
  final int lastServiceKm;

  Schedule({
    required this.id,
    required this.vehicleId,
    required this.type,
    required this.lastServiceDate,
    this.intervalDays,
    this.intervalKm,
    required this.nextDueDate,
    required this.lastServiceKm,
  });

  bool isOverdue(DateTime currentDate, int currentKm) {
    bool isTimeOverdue = currentDate.isAfter(nextDueDate);
    bool isKmOverdue = intervalKm != null
        ? currentKm >= (lastServiceKm + intervalKm!)
        : false;
    return isTimeOverdue || isKmOverdue;
  }

  bool isUpcoming(DateTime currentDate, int currentKm) {
    if (isOverdue(currentDate, currentKm)) return false;

    bool timeUpcoming = intervalDays != null
        ? currentDate.add(Duration(days: 7)).isAfter(nextDueDate)
        : false;

    bool kmUpcoming = intervalKm != null
        ? currentKm >= (lastServiceKm + intervalKm! - 500)
        : false;

    return timeUpcoming || kmUpcoming;
  }

  Schedule copyWith({
    String? id,
    String? vehicleId,
    ServiceType? type,
    DateTime? lastServiceDate,
    int? intervalDays,
    int? intervalKm,
    DateTime? nextDueDate,
    int? lastServiceKm,
  }) {
    return Schedule(
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

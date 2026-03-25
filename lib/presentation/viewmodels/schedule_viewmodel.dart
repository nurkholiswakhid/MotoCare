import 'package:flutter/material.dart';

import '../../core/entities/schedule.dart';
import '../../core/repositories/schedule_repository.dart';

class ScheduleViewModel extends ChangeNotifier {
  final ScheduleRepository _scheduleRepository;

  List<Schedule> _schedules = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Schedule> get schedules => _schedules;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  List<Schedule> get overdueSchedules =>
      _schedules.where((s) => s.isOverdue(DateTime.now(), 0)).toList();

  List<Schedule> get upcomingSchedules =>
      _schedules.where((s) => s.isUpcoming(DateTime.now(), 0)).toList();

  List<Schedule> get safeSchedules => _schedules
      .where(
        (s) =>
            !s.isOverdue(DateTime.now(), 0) && !s.isUpcoming(DateTime.now(), 0),
      )
      .toList();

  ScheduleViewModel({required ScheduleRepository scheduleRepository})
    : _scheduleRepository = scheduleRepository;

  Future<void> loadSchedules(String userId, String vehicleId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _schedules = await _scheduleRepository.getSchedulesByVehicle(
        userId,
        vehicleId,
      );
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createSchedule(String userId, Schedule schedule) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final newSchedule = await _scheduleRepository.createSchedule(
        userId,
        schedule,
      );
      _schedules.add(newSchedule);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateSchedule(String userId, Schedule schedule) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _scheduleRepository.updateSchedule(userId, schedule);
      final index = _schedules.indexWhere((s) => s.id == schedule.id);
      if (index != -1) {
        _schedules[index] = schedule;
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteSchedule(String userId, String scheduleId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _scheduleRepository.deleteSchedule(userId, scheduleId);
      _schedules.removeWhere((s) => s.id == scheduleId);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}

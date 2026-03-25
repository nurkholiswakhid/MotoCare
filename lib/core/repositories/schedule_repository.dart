import '../entities/schedule.dart';

abstract class ScheduleRepository {
  Future<List<Schedule>> getSchedulesByVehicle(String userId, String vehicleId);
  Future<Schedule> createSchedule(String userId, Schedule schedule);
  Future<void> updateSchedule(String userId, Schedule schedule);
  Future<void> deleteSchedule(String userId, String scheduleId);
  Future<Schedule?> getScheduleById(String userId, String scheduleId);
}

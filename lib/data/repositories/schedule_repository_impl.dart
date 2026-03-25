import '../../core/entities/schedule.dart';
import '../../core/repositories/schedule_repository.dart';
import '../datasources/schedule_remote_datasource.dart';
import '../models/schedule_model.dart';

class ScheduleRepositoryImpl implements ScheduleRepository {
  final ScheduleRemoteDataSource scheduleRemoteDataSource;

  ScheduleRepositoryImpl({required this.scheduleRemoteDataSource});

  @override
  Future<List<Schedule>> getSchedulesByVehicle(
    String userId,
    String vehicleId,
  ) async {
    return await scheduleRemoteDataSource.getSchedulesByVehicle(
      userId,
      vehicleId,
    );
  }

  @override
  Future<Schedule> createSchedule(String userId, Schedule schedule) async {
    final scheduleModel = ScheduleModel.fromEntity(schedule);
    return await scheduleRemoteDataSource.createSchedule(userId, scheduleModel);
  }

  @override
  Future<void> updateSchedule(String userId, Schedule schedule) async {
    final scheduleModel = ScheduleModel.fromEntity(schedule);
    await scheduleRemoteDataSource.updateSchedule(userId, scheduleModel);
  }

  @override
  Future<void> deleteSchedule(String userId, String scheduleId) async {
    await scheduleRemoteDataSource.deleteSchedule(userId, scheduleId);
  }

  @override
  Future<Schedule?> getScheduleById(String userId, String scheduleId) async {
    return await scheduleRemoteDataSource.getScheduleById(userId, scheduleId);
  }
}

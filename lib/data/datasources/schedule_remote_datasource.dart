import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '../models/schedule_model.dart';

abstract class ScheduleRemoteDataSource {
  Future<List<ScheduleModel>> getSchedulesByVehicle(
    String userId,
    String vehicleId,
  );
  Future<ScheduleModel> createSchedule(String userId, ScheduleModel schedule);
  Future<void> updateSchedule(String userId, ScheduleModel schedule);
  Future<void> deleteSchedule(String userId, String scheduleId);
  Future<ScheduleModel?> getScheduleById(String userId, String scheduleId);
}

class ScheduleRemoteDataSourceImpl implements ScheduleRemoteDataSource {
  final FirebaseFirestore firestore;

  ScheduleRemoteDataSourceImpl({required this.firestore});

  String _getSchedulesPath(String userId, String vehicleId) =>
      'users/$userId/vehicles/$vehicleId/schedules';

  @override
  Future<List<ScheduleModel>> getSchedulesByVehicle(
    String userId,
    String vehicleId,
  ) async {
    try {
      final snapshot = await firestore
          .collection('users')
          .doc(userId)
          .collection('vehicles')
          .doc(vehicleId)
          .collection('schedules')
          .get();

      return snapshot.docs
          .map((doc) => ScheduleModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ScheduleModel> createSchedule(
    String userId,
    ScheduleModel schedule,
  ) async {
    try {
      final scheduleId = const Uuid().v4();
      final scheduleData = schedule.copyWith(id: scheduleId) as ScheduleModel;

      await firestore
          .collection('users')
          .doc(userId)
          .collection('vehicles')
          .doc(schedule.vehicleId)
          .collection('schedules')
          .doc(scheduleId)
          .set(scheduleData.toJson());

      return scheduleData;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateSchedule(String userId, ScheduleModel schedule) async {
    try {
      await firestore
          .collection('users')
          .doc(userId)
          .collection('vehicles')
          .doc(schedule.vehicleId)
          .collection('schedules')
          .doc(schedule.id)
          .update(schedule.toJson());
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteSchedule(String userId, String scheduleId) async {
    try {
      // Note: In production, you'd need the vehicleId as well
      // This is a simplified version
      final snapshot = await firestore
          .collectionGroup('schedules')
          .where(FieldPath.documentId, isEqualTo: scheduleId)
          .get();

      for (final doc in snapshot.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ScheduleModel?> getScheduleById(
    String userId,
    String scheduleId,
  ) async {
    try {
      final snapshot = await firestore
          .collectionGroup('schedules')
          .where(FieldPath.documentId, isEqualTo: scheduleId)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) return null;
      return ScheduleModel.fromJson(snapshot.docs.first.data());
    } catch (e) {
      rethrow;
    }
  }
}

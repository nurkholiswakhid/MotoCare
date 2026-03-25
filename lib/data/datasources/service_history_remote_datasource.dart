import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '../models/service_history_model.dart';

abstract class ServiceHistoryRemoteDataSource {
  Future<List<ServiceHistoryModel>> getHistoryByVehicle(
    String userId,
    String vehicleId,
  );
  Future<ServiceHistoryModel> addToHistory(
    String userId,
    ServiceHistoryModel history,
  );
  Future<void> updateHistory(String userId, ServiceHistoryModel history);
  Future<void> deleteHistory(String userId, String historyId);
}

class ServiceHistoryRemoteDataSourceImpl
    implements ServiceHistoryRemoteDataSource {
  final FirebaseFirestore firestore;

  ServiceHistoryRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<ServiceHistoryModel>> getHistoryByVehicle(
    String userId,
    String vehicleId,
  ) async {
    try {
      final snapshot = await firestore
          .collection('users')
          .doc(userId)
          .collection('vehicles')
          .doc(vehicleId)
          .collection('history')
          .orderBy('date', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => ServiceHistoryModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ServiceHistoryModel> addToHistory(
    String userId,
    ServiceHistoryModel history,
  ) async {
    try {
      final historyId = const Uuid().v4();
      final historyData =
          history.copyWith(id: historyId) as ServiceHistoryModel;

      await firestore
          .collection('users')
          .doc(userId)
          .collection('vehicles')
          .doc(history.vehicleId)
          .collection('history')
          .doc(historyId)
          .set(historyData.toJson());

      return historyData;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateHistory(String userId, ServiceHistoryModel history) async {
    try {
      await firestore
          .collection('users')
          .doc(userId)
          .collection('vehicles')
          .doc(history.vehicleId)
          .collection('history')
          .doc(history.id)
          .update(history.toJson());
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteHistory(String userId, String historyId) async {
    try {
      final snapshot = await firestore
          .collectionGroup('history')
          .where(FieldPath.documentId, isEqualTo: historyId)
          .get();

      for (final doc in snapshot.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      rethrow;
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '../models/vehicle_model.dart';

abstract class VehicleRemoteDataSource {
  Future<List<VehicleModel>> getAllVehicles(String userId);
  Future<VehicleModel> addVehicle(String userId, VehicleModel vehicle);
  Future<void> updateVehicle(String userId, VehicleModel vehicle);
  Future<void> deleteVehicle(String userId, String vehicleId);
  Future<VehicleModel?> getVehicleById(String userId, String vehicleId);
}

class VehicleRemoteDataSourceImpl implements VehicleRemoteDataSource {
  final FirebaseFirestore firestore;

  VehicleRemoteDataSourceImpl({required this.firestore});

  String get _collection => 'users';
  String get _subcollection => 'vehicles';

  @override
  Future<List<VehicleModel>> getAllVehicles(String userId) async {
    try {
      final snapshot = await firestore
          .collection(_collection)
          .doc(userId)
          .collection(_subcollection)
          .get();

      return snapshot.docs
          .map((doc) => VehicleModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<VehicleModel> addVehicle(String userId, VehicleModel vehicle) async {
    try {
      final vehicleId = const Uuid().v4();
      final vehicleData = vehicle.copyWith(id: vehicleId) as VehicleModel;

      await firestore
          .collection(_collection)
          .doc(userId)
          .collection(_subcollection)
          .doc(vehicleId)
          .set(vehicleData.toJson());

      return vehicleData;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateVehicle(String userId, VehicleModel vehicle) async {
    try {
      await firestore
          .collection(_collection)
          .doc(userId)
          .collection(_subcollection)
          .doc(vehicle.id)
          .update(vehicle.toJson());
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteVehicle(String userId, String vehicleId) async {
    try {
      await firestore
          .collection(_collection)
          .doc(userId)
          .collection(_subcollection)
          .doc(vehicleId)
          .delete();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<VehicleModel?> getVehicleById(String userId, String vehicleId) async {
    try {
      final doc = await firestore
          .collection(_collection)
          .doc(userId)
          .collection(_subcollection)
          .doc(vehicleId)
          .get();

      if (!doc.exists) return null;
      return VehicleModel.fromJson(doc.data()!);
    } catch (e) {
      rethrow;
    }
  }
}

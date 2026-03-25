import '../../core/entities/vehicle.dart';
import '../../core/repositories/vehicle_repository.dart';
import '../datasources/vehicle_remote_datasource.dart';
import '../models/vehicle_model.dart';

class VehicleRepositoryImpl implements VehicleRepository {
  final VehicleRemoteDataSource vehicleRemoteDataSource;

  VehicleRepositoryImpl({required this.vehicleRemoteDataSource});

  @override
  Future<List<Vehicle>> getAllVehicles(String userId) async {
    return await vehicleRemoteDataSource.getAllVehicles(userId);
  }

  @override
  Future<Vehicle> addVehicle(String userId, Vehicle vehicle) async {
    final vehicleModel = VehicleModel.fromEntity(vehicle);
    return await vehicleRemoteDataSource.addVehicle(userId, vehicleModel);
  }

  @override
  Future<void> updateVehicle(String userId, Vehicle vehicle) async {
    final vehicleModel = VehicleModel.fromEntity(vehicle);
    await vehicleRemoteDataSource.updateVehicle(userId, vehicleModel);
  }

  @override
  Future<void> deleteVehicle(String userId, String vehicleId) async {
    await vehicleRemoteDataSource.deleteVehicle(userId, vehicleId);
  }

  @override
  Future<Vehicle?> getVehicleById(String userId, String vehicleId) async {
    return await vehicleRemoteDataSource.getVehicleById(userId, vehicleId);
  }
}

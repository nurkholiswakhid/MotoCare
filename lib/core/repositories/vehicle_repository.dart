import '../entities/vehicle.dart';

abstract class VehicleRepository {
  Future<List<Vehicle>> getAllVehicles(String userId);
  Future<Vehicle> addVehicle(String userId, Vehicle vehicle);
  Future<void> updateVehicle(String userId, Vehicle vehicle);
  Future<void> deleteVehicle(String userId, String vehicleId);
  Future<Vehicle?> getVehicleById(String userId, String vehicleId);
}

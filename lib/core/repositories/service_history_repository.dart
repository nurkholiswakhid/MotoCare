import '../entities/service_history.dart';

abstract class ServiceHistoryRepository {
  Future<List<ServiceHistory>> getHistoryByVehicle(
    String userId,
    String vehicleId,
  );
  Future<ServiceHistory> addToHistory(String userId, ServiceHistory history);
  Future<void> updateHistory(String userId, ServiceHistory history);
  Future<void> deleteHistory(String userId, String historyId);
}

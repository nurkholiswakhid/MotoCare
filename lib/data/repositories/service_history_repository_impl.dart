import '../../core/entities/service_history.dart';
import '../../core/repositories/service_history_repository.dart';
import '../datasources/service_history_remote_datasource.dart';
import '../models/service_history_model.dart';

class ServiceHistoryRepositoryImpl implements ServiceHistoryRepository {
  final ServiceHistoryRemoteDataSource serviceHistoryRemoteDataSource;

  ServiceHistoryRepositoryImpl({required this.serviceHistoryRemoteDataSource});

  @override
  Future<List<ServiceHistory>> getHistoryByVehicle(
    String userId,
    String vehicleId,
  ) async {
    return await serviceHistoryRemoteDataSource.getHistoryByVehicle(
      userId,
      vehicleId,
    );
  }

  @override
  Future<ServiceHistory> addToHistory(
    String userId,
    ServiceHistory history,
  ) async {
    final historyModel = ServiceHistoryModel.fromEntity(history);
    return await serviceHistoryRemoteDataSource.addToHistory(
      userId,
      historyModel,
    );
  }

  @override
  Future<void> updateHistory(String userId, ServiceHistory history) async {
    final historyModel = ServiceHistoryModel.fromEntity(history);
    await serviceHistoryRemoteDataSource.updateHistory(userId, historyModel);
  }

  @override
  Future<void> deleteHistory(String userId, String historyId) async {
    await serviceHistoryRemoteDataSource.deleteHistory(userId, historyId);
  }
}

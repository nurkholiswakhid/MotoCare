import 'package:flutter/material.dart';

import '../../core/entities/service_history.dart';
import '../../core/repositories/service_history_repository.dart';

class ServiceHistoryViewModel extends ChangeNotifier {
  final ServiceHistoryRepository _serviceHistoryRepository;

  List<ServiceHistory> _history = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<ServiceHistory> get history => _history;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  int get totalCost => _history.fold(0, (sum, h) => sum + h.costInRupiah);

  ServiceHistoryViewModel({
    required ServiceHistoryRepository serviceHistoryRepository,
  }) : _serviceHistoryRepository = serviceHistoryRepository;

  Future<void> loadHistory(String userId, String vehicleId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _history = await _serviceHistoryRepository.getHistoryByVehicle(
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

  Future<void> addToHistory(
    String userId,
    ServiceHistory serviceHistory,
  ) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final newHistory = await _serviceHistoryRepository.addToHistory(
        userId,
        serviceHistory,
      );
      _history.insert(0, newHistory);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateHistory(
    String userId,
    ServiceHistory serviceHistory,
  ) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _serviceHistoryRepository.updateHistory(userId, serviceHistory);
      final index = _history.indexWhere((h) => h.id == serviceHistory.id);
      if (index != -1) {
        _history[index] = serviceHistory;
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteHistory(String userId, String historyId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _serviceHistoryRepository.deleteHistory(userId, historyId);
      _history.removeWhere((h) => h.id == historyId);
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

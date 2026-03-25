import 'package:flutter/material.dart';

import '../../core/entities/vehicle.dart';
import '../../core/repositories/vehicle_repository.dart';

class VehicleViewModel extends ChangeNotifier {
  final VehicleRepository _vehicleRepository;

  List<Vehicle> _vehicles = [];
  Vehicle? _selectedVehicle;
  bool _isLoading = false;
  String? _errorMessage;

  List<Vehicle> get vehicles => _vehicles;
  Vehicle? get selectedVehicle => _selectedVehicle;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  VehicleViewModel({required VehicleRepository vehicleRepository})
    : _vehicleRepository = vehicleRepository;

  Future<void> loadVehicles(String userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _vehicles = await _vehicleRepository.getAllVehicles(userId);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addVehicle(String userId, Vehicle vehicle) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final newVehicle = await _vehicleRepository.addVehicle(userId, vehicle);
      _vehicles.add(newVehicle);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateVehicle(String userId, Vehicle vehicle) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _vehicleRepository.updateVehicle(userId, vehicle);
      final index = _vehicles.indexWhere((v) => v.id == vehicle.id);
      if (index != -1) {
        _vehicles[index] = vehicle;
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteVehicle(String userId, String vehicleId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _vehicleRepository.deleteVehicle(userId, vehicleId);
      _vehicles.removeWhere((v) => v.id == vehicleId);
      if (_selectedVehicle?.id == vehicleId) {
        _selectedVehicle = null;
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectVehicle(Vehicle vehicle) {
    _selectedVehicle = vehicle;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}

import 'package:flutter/foundation.dart';
import 'api_service.dart';
import '../models/shipment.dart';

class AddressService extends ChangeNotifier {
  List<Shipment> _shipments = [];
  bool _isLoading = false;
  int? _selectedId;

  List<Shipment> get shipments => _shipments;
  bool get isLoading => _isLoading;
  int? get selectedId => _selectedId;

  Shipment? get selectedShipment {
    for (final s in _shipments) {
      if (s.shipId == _selectedId) return s;
    }
    return _shipments.isNotEmpty ? _shipments.first : null;
  }

  void select(int id) {
    _selectedId = id;
    notifyListeners();
  }

  Future<void> fetchByUser(int userId) async {
    _isLoading = true;
    notifyListeners();
    try {
      print('[AddressService] Fetching shipments for userId: $userId');
      final response =
          await ApiService.get('/user-service/shipments/user/$userId');
      print('[AddressService] Response: $response');

      final List<dynamic> data = response['data'] ?? [];
      print('[AddressService] Data list: $data');
      print('[AddressService] Data count: ${data.length}');

      _shipments = data.map((e) {
        print('[AddressService] Parsing shipment: $e');
        return Shipment.fromJson(e);
      }).toList();

      print('[AddressService] Total shipments loaded: ${_shipments.length}');

      if (_selectedId == null && _shipments.isNotEmpty) {
        _selectedId = _shipments.first.shipId;
        print('[AddressService] Selected first shipment: $_selectedId');
      }
    } catch (e) {
      print('[AddressService] fetchByUser error: $e');
      _shipments = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Shipment?> create(Map<String, dynamic> payload) async {
    try {
      final response =
          await ApiService.post('/user-service/shipments', payload);
      final shipment = Shipment.fromJson(response['data']);
      _shipments.add(shipment);
      notifyListeners();
      return shipment;
    } catch (e) {
      print('AddressService.create error: $e');
      return null;
    }
  }

  Future<Shipment?> update(int id, Map<String, dynamic> payload) async {
    try {
      final response =
          await ApiService.put('/user-service/shipments/$id', payload);
      final updated = Shipment.fromJson(response['data']);
      final idx = _shipments.indexWhere((s) => s.shipId == id);
      if (idx != -1) _shipments[idx] = updated;
      notifyListeners();
      return updated;
    } catch (e) {
      print('AddressService.update error: $e');
      return null;
    }
  }

  Future<bool> delete(int id) async {
    try {
      await ApiService.delete('/user-service/shipments/$id');
      _shipments.removeWhere((s) => s.shipId == id);
      if (_selectedId == id) {
        _selectedId = _shipments.isNotEmpty ? _shipments.first.shipId : null;
      }
      notifyListeners();
      return true;
    } catch (e) {
      print('AddressService.delete error: $e');
      return false;
    }
  }
}

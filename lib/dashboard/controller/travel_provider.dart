import 'package:flutter/foundation.dart';
import 'package:travel_reimbursement/dashboard/model/travel_modelreq.dart';
import 'package:travel_reimbursement/dashboard/repository/travel_repo.dart';

class TravelProvider with ChangeNotifier {
  final TravelRepository _repository;

  List<TravelRequest> _requests = [];
  bool _isLoading = false;
  String? _error;

  TravelProvider(this._repository);

  List<TravelRequest> get requests => _requests;
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<TravelRequest> get pendingRequests =>
      _requests.where((req) => req.status.toLowerCase() == 'pending').toList();

  List<TravelRequest> get paidRequests =>
      _requests.where((req) => req.status.toLowerCase() == 'paid').toList();

  // -----------------------------
  // FETCH REQUESTS
  // -----------------------------
  Future<void> fetchRequests() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _requests = await _repository.getTravelRequests();
    } catch (e) {
      _error = e.toString();
      print("Fetch Error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // -----------------------------
  // ADD REQUEST
  // -----------------------------
  Future<bool> addRequest(String name, int km) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final body = CreateTravelRequest(name: name, km: km);
      final created = await _repository.createTravelRequest(body);

      _requests.add(created);

      notifyListeners();
      return true; // success
    } catch (e) {
      _error = e.toString();
      print("Add Error: $e");
      notifyListeners();
      return false; // failed
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // -----------------------------
  // UPDATE STATUS
  // -----------------------------
  Future<void> updateRequestStatus(String id, String status) async {
    try {
      _isLoading = true;
      notifyListeners();

      final updated = await _repository.updateTravelRequestStatus(id, status);

      final index = _requests.indexWhere((req) => req.id == id);
      if (index != -1) _requests[index] = updated;

      _error = null;
    } catch (e) {
      _error = e.toString();
      print("Status Update Error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // -----------------------------
  // DELETE REQUEST
  // -----------------------------
  Future<void> deleteRequest(String id) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _repository.deleteTravelRequest(id);
      _requests.removeWhere((req) => req.id == id);

      _error = null;
    } catch (e) {
      _error = e.toString();
      print("Delete Error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}

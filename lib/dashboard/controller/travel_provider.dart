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
      
      print("✅ Fetched ${_requests.length} requests successfully");
    } catch (e) {
      _error = e.toString();
      print("❌ Fetch Error: $e");
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

      print("📝 Adding request: name=$name, km=$km");

      final body = CreateTravelRequest(name: name, km: km);
      
      print("📤 Request body created: ${body.toJson()}");
      
      final created = await _repository.createTravelRequest(body);

      print("✅ Request created successfully: ${created.toString()}");

      // Add the new request to the list
      _requests.add(created);

      _error = null;
      _isLoading = false;
      notifyListeners();
      
      return true; // success
    } catch (e) {
      _error = e.toString();
      print("❌ Add Error: $e");
      
      _isLoading = false;
      notifyListeners();
      
      return false; // failed
    }
  }

  // -----------------------------
  // UPDATE STATUS
  // -----------------------------
  Future<void> updateRequestStatus(String id, String status) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      print("🔄 Updating request $id to status: $status");

      final updated = await _repository.updateTravelRequestStatus(id, status);

      final index = _requests.indexWhere((req) => req.id == id);
      if (index != -1) {
        _requests[index] = updated;
        print("✅ Request $id updated successfully");
      } else {
        print("⚠️ Request $id not found in local list");
      }

      _error = null;
    } catch (e) {
      _error = e.toString();
      print("❌ Status Update Error: $e");
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
      _error = null;
      notifyListeners();

      print("🗑️ Deleting request: $id");

      await _repository.deleteTravelRequest(id);
      
      _requests.removeWhere((req) => req.id == id);

      print("✅ Request $id deleted successfully");

      _error = null;
    } catch (e) {
      _error = e.toString();
      print("❌ Delete Error: $e");
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
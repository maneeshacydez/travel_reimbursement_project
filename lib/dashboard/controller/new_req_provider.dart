import 'package:flutter/foundation.dart';
import 'package:travel_reimbursement/dashboard/model/putreq_model.dart';
import 'package:travel_reimbursement/dashboard/repository/new_req.dart';

class ReqstCreateProvider with ChangeNotifier {
  final ReqstCreateRepository _repository;
  
  List<ReqstCreate> _requests = [];
  bool _isLoading = false;
  String? _error;

  List<ReqstCreate> get requests => _requests;
  bool get isLoading => _isLoading;
  String? get error => _error;

  ReqstCreateProvider(this._repository);

  Future<void> createRequest({
    required String name,
    required double km,
    String status = 'pending',
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final request = ReqstCreate(
        name: name,
        km: km,
        status: status,
      );
      
      final createdRequest = await _repository.createRequest(request);
      _requests.add(createdRequest);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchAllRequests() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _requests = await _repository.getAllRequests();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteRequest(String id) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _repository.deleteRequest(id);
      _requests.removeWhere((request) => request.id == id);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateRequest(ReqstCreate request) async {
    _isLoading = true;
    notifyListeners();

    try {
      final updatedRequest = await _repository.updateRequest(request);
      final index = _requests.indexWhere((r) => r.id == request.id);
      if (index != -1) {
        _requests[index] = updatedRequest;
      }
      _error = null;
    } catch (e) {
      _error = e.toString();
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
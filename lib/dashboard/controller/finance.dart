import 'package:flutter/foundation.dart';
import 'package:travel_reimbursement/dashboard/model/finance_list.dart';
import 'package:travel_reimbursement/dashboard/service/finance_list.dart';

class FinanceListProvider with ChangeNotifier {
  final FinanceListService _service = FinanceListService();
  List<Getfinancelist> _requests = [];
  bool _isLoading = false;
  String _error = '';

  List<Getfinancelist> get requests => _requests;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> loadFinanceRequests() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _requests = await _service.getFinanceRequests();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateStatus(String id, String status) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _service.updateRequestStatus(id, status);
      await loadFinanceRequests(); // Refresh the list
      _error = '';
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
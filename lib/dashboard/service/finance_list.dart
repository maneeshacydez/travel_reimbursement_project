// lib/dashboard/service/financelist_service.dart
import 'package:travel_reimbursement/dashboard/model/finance_list.dart';
import 'package:travel_reimbursement/dashboard/model/travel_modelreq.dart';
import 'package:travel_reimbursement/dashboard/repository/finance_list.dart';


class FinanceListService {
  final FinanceListRepository _repository = FinanceListRepository();

  Future<List<Getfinancelist>> getFinanceRequests() async {
    return await _repository.getAllFinanceRequests();
  }

  Future<List<TravelRequest>> getTravelRequests() async {
    final financeList = await _repository.getAllFinanceRequests();
    return financeList.map((finance) => finance.toTravelRequest()).toList();
  }

  Future<void> updateRequestStatus(String id, String status) async {
    await _repository.updateRequestStatus(id, status);
  }

  Future<Getfinancelist> getRequestById(String id) async {
    return await _repository.getFinanceRequestById(id);
  }
}
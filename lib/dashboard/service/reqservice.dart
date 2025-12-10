// service/travel_service.dart
import 'package:travel_reimbursement/dashboard/model/travel_modelreq.dart';
import 'package:travel_reimbursement/dashboard/repository/travel_repo.dart';


class TravelService {
  final TravelRepository _repository;

  TravelService({required TravelRepository repository}) : _repository = repository;

  Future<List<TravelRequest>> getRequests() async {
    return await _repository.getTravelRequests();
  }

  Future<TravelRequest> createRequest(String name, int km) async {
    final newRequest = CreateTravelRequest(name: name, km: km);
    return await _repository.createTravelRequest(newRequest);
  }

  Future<TravelRequest> updateRequest(String id, String status) async {
    return await _repository.updateTravelRequestStatus(id, status);
  }

  Future<void> deleteRequest(String id) async {
    await _repository.deleteTravelRequest(id);
  }
}
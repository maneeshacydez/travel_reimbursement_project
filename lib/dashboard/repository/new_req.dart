// lib/dashboard/repository/reqstcreate_repository.dart

import 'package:travel_reimbursement/dashboard/model/putreq_model.dart';
import 'package:travel_reimbursement/dashboard/service/newreq_service.dart';

abstract class ReqstCreateRepository {
  Future<ReqstCreate> createRequest(ReqstCreate request);
  Future<List<ReqstCreate>> getAllRequests();
  Future<ReqstCreate> getRequestById(String id);
  Future<void> deleteRequest(String id);
  Future<ReqstCreate> updateRequest(ReqstCreate request);
}

class ReqstCreateRepositoryImpl implements ReqstCreateRepository {
  final ReqstCreateService _service;

  ReqstCreateRepositoryImpl(this._service);

  @override
  Future<ReqstCreate> createRequest(ReqstCreate request) async {
    try {
      final response = await _service.createRequest(request);
      return ReqstCreate.fromJson(response['data']);
    } catch (e) {
      throw Exception('Failed to create request: $e');
    }
  }

  @override
  Future<List<ReqstCreate>> getAllRequests() async {
    try {
      final response = await _service.getAllRequests();
      final List<dynamic> data = response['data'] ?? [];
      return data.map((json) => ReqstCreate.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch requests: $e');
    }
  }

  @override
  Future<ReqstCreate> getRequestById(String id) async {
    try {
      final response = await _service.getRequestById(id);
      return ReqstCreate.fromJson(response['data']);
    } catch (e) {
      throw Exception('Failed to fetch request: $e');
    }
  }

  @override
  Future<void> deleteRequest(String id) async {
    try {
      await _service.deleteRequest(id);
    } catch (e) {
      throw Exception('Failed to delete request: $e');
    }
  }

  @override
  Future<ReqstCreate> updateRequest(ReqstCreate request) async {
    try {
      final response = await _service.updateRequest(request);
      return ReqstCreate.fromJson(response['data']);
    } catch (e) {
      throw Exception('Failed to update request: $e');
    }
  }
}
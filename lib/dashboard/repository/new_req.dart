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
      print('📝 Creating request: ${request.toString()}');
      
      final response = await _service.createRequest(request);
      
      print('📥 Create Response: $response');
      
      final createdRequest = ReqstCreate.fromJson(response['data']);
      
      print('✅ Request created successfully: ${createdRequest.toString()}');
      
      return createdRequest;
    } catch (e) {
      print('❌ Create Request Error: $e');
      throw Exception('Failed to create request: $e');
    }
  }

  @override
  Future<List<ReqstCreate>> getAllRequests() async {
    try {
      print('📡 Fetching all requests...');
      
      final response = await _service.getAllRequests();
      
      print('📥 Get All Response: $response');
      
      final List<dynamic> data = response['data'] ?? [];
      
      final requests = data.map((json) => ReqstCreate.fromJson(json)).toList();
      
      print('✅ Fetched ${requests.length} requests successfully');
      
      return requests;
    } catch (e) {
      print('❌ Get All Requests Error: $e');
      throw Exception('Failed to fetch requests: $e');
    }
  }

  @override
  Future<ReqstCreate> getRequestById(String id) async {
    try {
      print('📡 Fetching request by ID: $id');
      
      final response = await _service.getRequestById(id);
      
      print('📥 Get By ID Response: $response');
      
      final request = ReqstCreate.fromJson(response['data']);
      
      print('✅ Request fetched successfully: ${request.toString()}');
      
      return request;
    } catch (e) {
      print('❌ Get Request By ID Error: $e');
      throw Exception('Failed to fetch request: $e');
    }
  }

  @override
  Future<void> deleteRequest(String id) async {
    try {
      print('🗑️ Deleting request: $id');
      
      await _service.deleteRequest(id);
      
      print('✅ Request deleted successfully: $id');
    } catch (e) {
      print('❌ Delete Request Error: $e');
      throw Exception('Failed to delete request: $e');
    }
  }

  @override
  Future<ReqstCreate> updateRequest(ReqstCreate request) async {
    try {
      print('🔄 Updating request: ${request.toString()}');
      
      final response = await _service.updateRequest(request);
      
      print('📥 Update Response: $response');
      
      final updatedRequest = ReqstCreate.fromJson(response['data']);
      
      print('✅ Request updated successfully: ${updatedRequest.toString()}');
      
      return updatedRequest;
    } catch (e) {
      print('❌ Update Request Error: $e');
      throw Exception('Failed to update request: $e');
    }
  }
}
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:travel_reimbursement/dashboard/model/travel_modelreq.dart';

class TravelRepository {
  static const String baseUrl = 'http://10.0.2.2:8393/api/TravelReimbursements';
  
  final http.Client client;

  TravelRepository({required this.client});

  Future<List<TravelRequest>> getTravelRequests() async {
    try {
      print('📡 GET Request to: $baseUrl');
      
      final response = await client.get(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      print('📥 GET Status: ${response.statusCode}');
      print('📥 GET Response: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        final requests = jsonData.map((e) => TravelRequest.fromJson(e)).toList();
        print('✅ Parsed ${requests.length} requests');
        return requests;
      } else {
        final errorBody = response.body;
        print('❌ GET Failed: ${response.statusCode} - $errorBody');
        throw Exception('Failed to load requests: ${response.statusCode} - $errorBody');
      }
    } catch (e) {
      print('❌ GET Error: $e');
      throw Exception('Failed to load requests: $e');
    }
  }

  Future<TravelRequest> createTravelRequest(CreateTravelRequest request) async {
    try {
      final requestBody = request.toJson();
      
      print('📡 POST Request to: $baseUrl');
      print('📤 POST Body: ${json.encode(requestBody)}');
      
      final response = await client.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(requestBody),
      );

      print('📥 POST Status: ${response.statusCode}');
      print('📥 POST Response: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = json.decode(response.body);
        
        // Your API wraps the response in a 'data' object
        final Map<String, dynamic> jsonData = responseData['data'] ?? responseData;
        
        final createdRequest = TravelRequest.fromJson(jsonData);
        print('✅ Request created: ${createdRequest.toString()}');
        return createdRequest;
      } else {
        final errorBody = response.body;
        print('❌ POST Failed: ${response.statusCode} - $errorBody');
        
        // Try to parse error message
        String errorMessage;
        try {
          final errorJson = json.decode(errorBody);
          errorMessage = errorJson['message'] ?? 
                        errorJson['error'] ?? 
                        errorJson['title'] ??
                        errorJson['Message'] ??
                        errorBody;
        } catch (_) {
          errorMessage = errorBody;
        }
        
        throw Exception('Failed to create request: $errorMessage');
      }
    } catch (e) {
      print('❌ POST Error: $e');
      rethrow;
    }
  }

  Future<TravelRequest> updateTravelRequestStatus(String id, String status) async {
    try {
      final requestBody = {'status': status};
      
      print('📡 PATCH Request to: $baseUrl/$id');
      print('📤 PATCH Body: ${json.encode(requestBody)}');
      
      final response = await client.patch(
        Uri.parse('$baseUrl/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(requestBody),
      );

      print('📥 PATCH Status: ${response.statusCode}');
      print('📥 PATCH Response: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        final updatedRequest = TravelRequest.fromJson(jsonData);
        print('✅ Request updated: ${updatedRequest.toString()}');
        return updatedRequest;
      } else {
        final errorBody = response.body;
        print('❌ PATCH Failed: ${response.statusCode} - $errorBody');
        
        String errorMessage;
        try {
          final errorJson = json.decode(errorBody);
          errorMessage = errorJson['message'] ?? errorJson['error'] ?? errorBody;
        } catch (_) {
          errorMessage = errorBody;
        }
        
        throw Exception('Failed to update request: $errorMessage');
      }
    } catch (e) {
      print('❌ PATCH Error: $e');
      rethrow;
    }
  }

  Future<void> deleteTravelRequest(String id) async {
    try {
      print('📡 DELETE Request to: $baseUrl/$id');
      
      final response = await client.delete(
        Uri.parse('$baseUrl/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      print('📥 DELETE Status: ${response.statusCode}');
      print('📥 DELETE Response: ${response.body}');

      if (response.statusCode != 200 && response.statusCode != 204) {
        final errorBody = response.body;
        print('❌ DELETE Failed: ${response.statusCode} - $errorBody');
        
        String errorMessage;
        try {
          final errorJson = json.decode(errorBody);
          errorMessage = errorJson['message'] ?? errorJson['error'] ?? errorBody;
        } catch (_) {
          errorMessage = errorBody;
        }
        
        throw Exception('Failed to delete request: $errorMessage');
      }
      
      print('✅ Request deleted successfully');
    } catch (e) {
      print('❌ DELETE Error: $e');
      rethrow;
    }
  }
}
// repository/travel_repository.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:travel_reimbursement/dashboard/model/travel_modelreq.dart';

class TravelRepository {
  static const String baseUrl = 'http://10.0.2.2:8393/api/TravelReimbursements';
  
  final http.Client client;

  TravelRepository({required this.client});

  Future<List<TravelRequest>> getTravelRequests() async {
    try {
      final response = await client.get(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((e) => TravelRequest.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load requests: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load requests: $e');
    }
  }

  Future<TravelRequest> createTravelRequest(CreateTravelRequest request) async {
    try {
      final response = await client.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(request.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        return TravelRequest.fromJson(jsonData);
      } else {
        throw Exception('Failed to create request: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to create request: $e');
    }
  }

  Future<TravelRequest> updateTravelRequestStatus(String id, String status) async {
    try {
      final response = await client.patch(
        Uri.parse('$baseUrl/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({'status': status}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        return TravelRequest.fromJson(jsonData);
      } else {
        throw Exception('Failed to update request: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to update request: $e');
    }
  }

  Future<void> deleteTravelRequest(String id) async {
    try {
      final response = await client.delete(
        Uri.parse('$baseUrl/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to delete request: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to delete request: $e');
    }
  }
}
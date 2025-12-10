// lib/dashboard/repository/financelist_repository.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:travel_reimbursement/dashboard/model/finance_list.dart';

class FinanceListRepository {
  final String baseUrl = 'http://10.0.2.2:8393/api/TravelReimbursements';

  Future<List<Getfinancelist>> getAllFinanceRequests() async {
    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => Getfinancelist.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load requests: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch requests: $e');
    }
  }

  Future<Getfinancelist> getFinanceRequestById(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$id'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return Getfinancelist.fromJson(jsonData);
      } else {
        throw Exception('Failed to load request: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch request: $e');
    }
  }

  Future<void> updateRequestStatus(String id, String status) async {
    try {
      // First get the current request
      final currentRequest = await getFinanceRequestById(id);
      
      // Update the status
      final updatedRequest = Getfinancelist(
        id: currentRequest.id,
        name: currentRequest.name,
        km: currentRequest.km,
        status: status,
        timestamp: currentRequest.timestamp,
      );

      final response = await http.put(
        Uri.parse('$baseUrl/$id'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(updatedRequest.toJson()),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to update request: $e');
    }
  }
}
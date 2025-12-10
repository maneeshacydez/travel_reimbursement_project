// lib/dashboard/service/newreq_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:travel_reimbursement/dashboard/model/putreq_model.dart';

abstract class ReqstCreateService {
  Future<Map<String, dynamic>> createRequest(ReqstCreate request);
  Future<Map<String, dynamic>> getAllRequests();
  Future<Map<String, dynamic>> getRequestById(String id);
  Future<Map<String, dynamic>> deleteRequest(String id);
  Future<Map<String, dynamic>> updateRequest(ReqstCreate request);
}

class ReqstCreateServiceImpl implements ReqstCreateService {
  static const String _baseUrl = 'http://10.0.2.2:8393/api/TravelReimbursements';
  final http.Client _client;
  final Logger _logger;

  ReqstCreateServiceImpl({http.Client? client})
      : _client = client ?? http.Client(),
        _logger = Logger(
          printer: PrettyPrinter(
            methodCount: 0,
            errorMethodCount: 5,
            lineLength: 80,
            colors: true,
            printEmojis: true,
            printTime: true,
          ),
        );

  @override
  Future<Map<String, dynamic>> createRequest(ReqstCreate request) async {
    _logger.i('📤 Creating new request');
    _logger.d('Request URL: $_baseUrl/');
    _logger.d('Request Body: ${jsonEncode(request.toJson())}');

    try {
      final response = await _client.post(
        Uri.parse('$_baseUrl/'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(request.toJson()),
      );

      _logger.i('📥 Create Request Response');
      _logger.d('Status Code: ${response.statusCode}');
      _logger.d('Response Headers: ${response.headers}');
      _logger.d('Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        _logger.i('✅ Request created successfully');
        final responseData = jsonDecode(response.body);
        _logger.d('Decoded Response: $responseData');
        return responseData;
      } else {
        _logger.e('❌ Failed to create request');
        _logger.e('Status Code: ${response.statusCode}');
        _logger.e('Response: ${response.body}');
        throw Exception('Failed to create request: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      _logger.e('🔥 Network error occurred', error: e, stackTrace: stackTrace);
      throw Exception('Network error: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getAllRequests() async {
    _logger.i('📤 Fetching all requests');
    _logger.d('Request URL: $_baseUrl/');

    try {
      final response = await _client.get(
        Uri.parse('$_baseUrl/'),
        headers: {'Content-Type': 'application/json'},
      );

      _logger.i('📥 Get All Requests Response');
      _logger.d('Status Code: ${response.statusCode}');
      _logger.d('Response Headers: ${response.headers}');
      _logger.d('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        _logger.i('✅ Requests fetched successfully');
        final responseData = jsonDecode(response.body);
        _logger.d('Decoded Response: $responseData');
        
        if (responseData is List) {
          _logger.d('Total requests: ${responseData.length}');
        }
        
        return responseData;
      } else {
        _logger.e('❌ Failed to fetch requests');
        _logger.e('Status Code: ${response.statusCode}');
        _logger.e('Response: ${response.body}');
        throw Exception('Failed to fetch requests: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      _logger.e('🔥 Network error occurred', error: e, stackTrace: stackTrace);
      throw Exception('Network error: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getRequestById(String id) async {
    _logger.i('📤 Fetching request by ID: $id');
    _logger.d('Request URL: $_baseUrl/$id');

    try {
      final response = await _client.get(
        Uri.parse('$_baseUrl/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      _logger.i('📥 Get Request By ID Response');
      _logger.d('Status Code: ${response.statusCode}');
      _logger.d('Response Headers: ${response.headers}');
      _logger.d('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        _logger.i('✅ Request fetched successfully');
        final responseData = jsonDecode(response.body);
        _logger.d('Decoded Response: $responseData');
        return responseData;
      } else {
        _logger.e('❌ Failed to fetch request');
        _logger.e('Status Code: ${response.statusCode}');
        _logger.e('Response: ${response.body}');
        throw Exception('Failed to fetch request: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      _logger.e('🔥 Network error occurred', error: e, stackTrace: stackTrace);
      throw Exception('Network error: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> deleteRequest(String id) async {
    _logger.i('📤 Deleting request ID: $id');
    _logger.d('Request URL: $_baseUrl/$id');

    try {
      final response = await _client.delete(
        Uri.parse('$_baseUrl/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      _logger.i('📥 Delete Request Response');
      _logger.d('Status Code: ${response.statusCode}');
      _logger.d('Response Headers: ${response.headers}');
      _logger.d('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        _logger.i('✅ Request deleted successfully');
        final responseData = jsonDecode(response.body);
        _logger.d('Decoded Response: $responseData');
        return responseData;
      } else {
        _logger.e('❌ Failed to delete request');
        _logger.e('Status Code: ${response.statusCode}');
        _logger.e('Response: ${response.body}');
        throw Exception('Failed to delete request: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      _logger.e('🔥 Network error occurred', error: e, stackTrace: stackTrace);
      throw Exception('Network error: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> updateRequest(ReqstCreate request) async {
    _logger.i('📤 Updating request');
    _logger.d('Request URL: $_baseUrl/');
    _logger.d('Request Body: ${jsonEncode(request.toJson())}');

    try {
      final response = await _client.put(
        Uri.parse('$_baseUrl/'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(request.toJson()),
      );

      _logger.i('📥 Update Request Response');
      _logger.d('Status Code: ${response.statusCode}');
      _logger.d('Response Headers: ${response.headers}');
      _logger.d('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        _logger.i('✅ Request updated successfully');
        final responseData = jsonDecode(response.body);
        _logger.d('Decoded Response: $responseData');
        return responseData;
      } else {
        _logger.e('❌ Failed to update request');
        _logger.e('Status Code: ${response.statusCode}');
        _logger.e('Response: ${response.body}');
        throw Exception('Failed to update request: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      _logger.e('🔥 Network error occurred', error: e, stackTrace: stackTrace);
      throw Exception('Network error: $e');
    }
  }
}
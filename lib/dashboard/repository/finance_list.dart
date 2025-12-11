// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:travel_reimbursement/dashboard/model/finance_list.dart';

// class FinanceListRepository {
//   final String baseUrl = 'http://10.0.2.2:8393/api/TravelReimbursements';

//   Future<List<Getfinancelist>> getAllFinanceRequests() async {
//     try {
//       print('📡 GET Request to: $baseUrl');
      
//       final response = await http.get(
//         Uri.parse(baseUrl),
//         headers: {
//           'Content-Type': 'application/json',
//         },
//       );

//       print('📥 GET Status: ${response.statusCode}');
//       print('📥 GET Response Body: ${response.body}');

//       if (response.statusCode == 200) {
//         final List<dynamic> jsonList = json.decode(response.body);
        
//         final requests = jsonList.map((json) => Getfinancelist.fromJson(json)).toList();
        
//         print('✅ Fetched ${requests.length} finance requests successfully');
        
//         return requests;
//       } else {
//         print('❌ GET Failed: ${response.statusCode}');
//         throw Exception('Failed to load requests: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('❌ Get All Finance Requests Error: $e');
//       throw Exception('Failed to fetch requests: $e');
//     }
//   }

//   Future<Getfinancelist> getFinanceRequestById(String id) async {
//     try {
//       final url = '$baseUrl/$id';
//       print('📡 GET Request to: $url');
      
//       final response = await http.get(
//         Uri.parse(url),
//         headers: {
//           'Content-Type': 'application/json',
//         },
//       );

//       print('📥 GET By ID Status: ${response.statusCode}');
//       print('📥 GET By ID Response: ${response.body}');

//       if (response.statusCode == 200) {
//         final jsonData = json.decode(response.body);
        
//         // Handle wrapped response if API returns {data: {...}}
//         final requestData = jsonData['data'] ?? jsonData;
        
//         final request = Getfinancelist.fromJson(requestData);
        
//         print('✅ Finance request fetched successfully: ${request.toString()}');
        
//         return request;
//       } else {
//         print('❌ GET By ID Failed: ${response.statusCode}');
//         throw Exception('Failed to load request: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('❌ Get Finance Request By ID Error: $e');
//       throw Exception('Failed to fetch request: $e');
//     }
//   }

//   Future<void> updateRequestStatus(String id, String status) async {
//     try {
//       print('🔄 Updating status for request: $id to status: $status');
      
//       // First get the current request
//       print('📡 Fetching current request data...');
//       final currentRequest = await getFinanceRequestById(id);
      
//       // Update the status
//       final updatedRequest = Getfinancelist(
//         id: currentRequest.id,
//         name: currentRequest.name,
//         km: currentRequest.km,
//         status: status,
//         timestamp: currentRequest.timestamp,
//       );

//       final url = '$baseUrl/$id';
//       final requestBody = updatedRequest.toJson();
      
//       print('📡 PUT Request to: $url');
//       print('📤 PUT Body: ${json.encode(requestBody)}');

//       final response = await http.put(
//         Uri.parse(url),
//         headers: {
//           'Content-Type': 'application/json',
//           'Accept': 'application/json',
//         },
//         body: json.encode(requestBody),
//       );

//       print('📥 PUT Status: ${response.statusCode}');
//       print('📥 PUT Response: ${response.body}');

//       if (response.statusCode == 200) {
//         print('✅ Status updated successfully for request: $id');
//       } else {
//         print('❌ PUT Failed: ${response.statusCode}');
        
//         // Try to parse error message
//         String errorMessage;
//         try {
//           final errorData = json.decode(response.body);
//           errorMessage = errorData['message'] ?? 
//                         errorData['error'] ?? 
//                         errorData['title'] ?? 
//                         response.body;
//         } catch (_) {
//           errorMessage = response.body;
//         }
        
//         throw Exception('Failed to update status: $errorMessage');
//       }
//     } catch (e) {
//       print('❌ Update Request Status Error: $e');
//       throw Exception('Failed to update request: $e');
//     }
//   }

//   // Additional method for PATCH if your API prefers it
//   Future<void> patchRequestStatus(String id, String status) async {
//     try {
//       print('🔄 Patching status for request: $id to status: $status');
      
//       final url = '$baseUrl/$id';
      
//       // Your API expects capital S for Status
//       final requestBody = {'Status': status};
      
//       print('📡 PATCH Request to: $url');
//       print('📤 PATCH Body: ${json.encode(requestBody)}');

//       final response = await http.patch(
//         Uri.parse(url),
//         headers: {
//           'Content-Type': 'application/json',
//           'Accept': 'application/json',
//         },
//         body: json.encode(requestBody),
//       );

//       print('📥 PATCH Status: ${response.statusCode}');
//       print('📥 PATCH Response: ${response.body}');

//       if (response.statusCode == 200) {
//         print('✅ Status patched successfully for request: $id');
//       } else {
//         print('❌ PATCH Failed: ${response.statusCode}');
        
//         String errorMessage;
//         try {
//           final errorData = json.decode(response.body);
//           errorMessage = errorData['message'] ?? 
//                         errorData['error'] ?? 
//                         errorData['title'] ?? 
//                         response.body;
//         } catch (_) {
//           errorMessage = response.body;
//         }
        
//         throw Exception('Failed to patch status: $errorMessage');
//       }
//     } catch (e) {
//       print('❌ Patch Request Status Error: $e');
//       throw Exception('Failed to patch request: $e');
//     }
//   }
// }



// lib/dashboard/repository/financelist_repository.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:travel_reimbursement/dashboard/model/finance_list.dart';

class FinanceListRepository {
  final String baseUrl = 'http://10.0.2.2:8393/api/TravelReimbursements';
  

  Future<List<Getfinancelist>> getAllFinanceRequests() async {
    try {
      print('📡 GET Request to: $baseUrl');
      
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      print('📥 GET Status: ${response.statusCode}');
      print('📥 GET Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        
        final requests = jsonList.map((json) => Getfinancelist.fromJson(json)).toList();
        
        print('✅ Fetched ${requests.length} finance requests successfully');
        
        return requests;
      } else {
        print('❌ GET Failed: ${response.statusCode}');
        throw Exception('Failed to load requests: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Get All Finance Requests Error: $e');
      throw Exception('Failed to fetch requests: $e');
    }
  }

  Future<Getfinancelist> getFinanceRequestById(String id) async {
    try {
      final url = '$baseUrl/$id';
      print('📡 GET Request to: $url');
      
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      print('📥 GET By ID Status: ${response.statusCode}');
      print('📥 GET By ID Response: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        
        // Handle wrapped response if API returns {data: {...}}
        final requestData = jsonData['data'] ?? jsonData;
        
        final request = Getfinancelist.fromJson(requestData);
        
        print('✅ Finance request fetched successfully: ${request.toString()}');
        
        return request;
      } else {
        print('❌ GET By ID Failed: ${response.statusCode}');
        throw Exception('Failed to load request: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Get Finance Request By ID Error: $e');
      throw Exception('Failed to fetch request: $e');
    }
  }

  Future<void> updateRequestStatus(String id, String status) async {
    try {
      print('🔄 Updating status for request: $id to status: $status');
      
      // First get the current request
      print('📡 Fetching current request data...');
      final currentRequest = await getFinanceRequestById(id);
      
      // Update the status
      final updatedRequest = Getfinancelist(
        id: currentRequest.id,
        name: currentRequest.name,
        km: currentRequest.km,
        status: status,
        timestamp: currentRequest.timestamp,
      );

      final url = '$baseUrl/$id';
      final requestBody = updatedRequest.toJson();
      
      print('📡 PUT Request to: $url');
      print('📤 PUT Body: ${json.encode(requestBody)}');

      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(requestBody),
      );

      print('📥 PUT Status: ${response.statusCode}');
      print('📥 PUT Response: ${response.body}');

      if (response.statusCode == 200) {
        print('✅ Status updated successfully for request: $id');
      } else {
        print('❌ PUT Failed: ${response.statusCode}');
        
        // Try to parse error message
        String errorMessage;
        try {
          final errorData = json.decode(response.body);
          errorMessage = errorData['message'] ?? 
                        errorData['error'] ?? 
                        errorData['title'] ?? 
                        response.body;
        } catch (_) {
          errorMessage = response.body;
        }
        
        throw Exception('Failed to update status: $errorMessage');
      }
    } catch (e) {
      print('❌ Update Request Status Error: $e');
      throw Exception('Failed to update request: $e');
    }
  }

  // Additional method for PATCH if your API prefers it
  Future<void> patchRequestStatus(String id, String status) async {
    try {
      print('🔄 Patching status for request: $id to status: $status');
      
      final url = '$baseUrl/$id';
      
      // Your API expects capital S for Status
      final requestBody = {'Status': status};
      
      print('📡 PATCH Request to: $url');
      print('📤 PATCH Body: ${json.encode(requestBody)}');

      final response = await http.patch(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(requestBody),
      );

      print('📥 PATCH Status: ${response.statusCode}');
      print('📥 PATCH Response: ${response.body}');

      if (response.statusCode == 200) {
        print('✅ Status patched successfully for request: $id');
      } else {
        print('❌ PATCH Failed: ${response.statusCode}');
        
        String errorMessage;
        try {
          final errorData = json.decode(response.body);
          errorMessage = errorData['message'] ?? 
                        errorData['error'] ?? 
                        errorData['title'] ?? 
                        response.body;
        } catch (_) {
          errorMessage = response.body;
        }
        
        throw Exception('Failed to patch status: $errorMessage');
      }
    } catch (e) {
      print('❌ Patch Request Status Error: $e');
      throw Exception('Failed to patch request: $e');
    }
  }

  // Delete finance request
  Future<void> deleteFinanceRequest(String id) async {
    try {
      final url = '$baseUrl/$id';
      print('📡 DELETE Request to: $url');

      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      print('📥 DELETE Status: ${response.statusCode}');
      print('📥 DELETE Response: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 204) {
        print('✅ Finance request deleted successfully: $id');
      } else {
        print('❌ DELETE Failed: ${response.statusCode}');
        
        String errorMessage;
        try {
          final errorData = json.decode(response.body);
          errorMessage = errorData['message'] ?? 
                        errorData['error'] ?? 
                        errorData['title'] ?? 
                        response.body;
        } catch (_) {
          errorMessage = response.body;
        }
        
        throw Exception('Failed to delete request: $errorMessage');
      }
    } catch (e) {
      print('❌ Delete Finance Request Error: $e');
      throw Exception('Failed to delete request: $e');
    }
  }
}
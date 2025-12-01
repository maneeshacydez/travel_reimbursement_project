import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travel_reimbursement/dashboard/model/travel_modelreq.dart';


class RequestService {
  static const String key = "travel_requests";

  /// Load all requests
  static Future<List<TravelRequest>> getRequests() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? raw = prefs.getString(key);

    if (raw == null) return [];

    List decoded = jsonDecode(raw);
    return decoded.map((e) => TravelRequest.fromMap(e)).toList();
  }

  /// Add new request
  static Future<void> addRequest(TravelRequest req) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<TravelRequest> current = await getRequests();

    current.add(req);

    prefs.setString(
      key,
      jsonEncode(current.map((e) => e.toMap()).toList()),
    );
  }



    /// Update Request Status (Pending → Paid)
  static Future<void> updateStatus(String id, String newStatus) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? raw = prefs.getString(key);
    if (raw == null) return;

    List decoded = jsonDecode(raw);

    List<TravelRequest> requests =
        decoded.map((e) => TravelRequest.fromMap(e)).toList();

    for (var req in requests) {
      if (req.id == id) {
        req.status = newStatus;
      }
    }

    prefs.setString(
      key,
      jsonEncode(requests.map((e) => e.toMap()).toList()),
    );
  }

}

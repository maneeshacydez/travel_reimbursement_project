import 'dart:convert';

import 'package:travel_reimbursement/dashboard/model/travel_modelreq.dart';

Getfinancelist getfinancelistFromJson(String str) => Getfinancelist.fromJson(json.decode(str));

String getfinancelistToJson(Getfinancelist data) => json.encode(data.toJson());

class Getfinancelist {
  String? id;
  String? name;
  int? km;
  String? status;
  DateTime? timestamp;

  Getfinancelist({
    this.id,
    this.name,
    this.km,
    this.status,
    this.timestamp,
  });

  factory Getfinancelist.fromJson(Map<String, dynamic> json) => Getfinancelist(
    id: json["id"],
    name: json["name"],
    km: json["km"],
    status: json["status"],
    timestamp: json["timestamp"] == null ? null : DateTime.parse(json["timestamp"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "km": km,
    "status": status,
    "timestamp": timestamp?.toIso8601String(),
  };

  // Add this method to convert to TravelRequest
  TravelRequest toTravelRequest() {
    return TravelRequest(
      id: id.toString(),
      name: name.toString(),
      km: km ?? 0,
      status: status.toString(),
      timestamp: timestamp ?? DateTime.now(),
    );
  }
}
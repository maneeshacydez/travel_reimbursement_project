// models/travel_request_model.dart
class TravelRequest {
  final String id;
  final String name;
  final int km;
  final String status;
  final DateTime timestamp;

  TravelRequest({
    required this.id,
    required this.name,
    required this.km,
    required this.status,
    required this.timestamp,
  });

  factory TravelRequest.fromJson(Map<String, dynamic> json) {
    return TravelRequest(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      km: json['km'] is int ? json['km'] : int.tryParse(json['km'].toString()) ?? 0,
      status: json['status'] ?? 'pending',
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'km': km,
      'status': status,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  TravelRequest copyWith({
    String? id,
    String? name,
    int? km,
    String? status,
    DateTime? timestamp,
  }) {
    return TravelRequest(
      id: id ?? this.id,
      name: name ?? this.name,
      km: km ?? this.km,
      status: status ?? this.status,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}

class CreateTravelRequest {
  final String name;
  final int km;

  CreateTravelRequest({
    required this.name,
    required this.km,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'km': km,
    };
  }
}
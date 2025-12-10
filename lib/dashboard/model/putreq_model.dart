// lib/dashboard/model/reqstcreate.dart

class ReqstCreate {
  final String? id;
  final String name;
  final double km;
  final String status;
  final DateTime? timestamp;

  ReqstCreate({
    this.id,
    required this.name,
    required this.km,
    required this.status,
    this.timestamp,
  });

  factory ReqstCreate.fromJson(Map<String, dynamic> json) {
    return ReqstCreate(
      id: json['id']?.toString(),
      name: json['name'] ?? '',
      km: (json['km'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] ?? 'pending',
      timestamp: json['timestamp'] != null
          ? DateTime.tryParse(json['timestamp'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'km': km,
      'status': status,
      'timestamp': timestamp?.toIso8601String(),
    };
  }

  ReqstCreate copyWith({
    String? id,
    String? name,
    double? km,
    String? status,
    DateTime? timestamp,
  }) {
    return ReqstCreate(
      id: id ?? this.id,
      name: name ?? this.name,
      km: km ?? this.km,
      status: status ?? this.status,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
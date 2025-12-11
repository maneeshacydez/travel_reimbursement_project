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
    print('🔄 Parsing TravelRequest from JSON: $json');
    
    try {
      return TravelRequest(
        id: json['id']?.toString() ?? 
            json['Id']?.toString() ?? 
            json['ID']?.toString() ?? 
            '',
        
        name: json['name']?.toString() ?? 
              json['Name']?.toString() ?? 
              json['clientName']?.toString() ?? 
              json['ClientName']?.toString() ?? 
              '',
        
        km: _parseKm(json['km'] ?? json['Km'] ?? json['KM'] ?? 0),
        
        status: (json['status']?.toString() ?? 
                json['Status']?.toString() ?? 
                'pending').toLowerCase(),
        
        timestamp: _parseTimestamp(
          json['timestamp'] ?? 
          json['Timestamp'] ?? 
          json['createdAt'] ?? 
          json['CreatedAt'] ?? 
          json['created_at'] ?? 
          json['date'] ?? 
          json['Date']
        ),
      );
    } catch (e) {
      print('❌ Error parsing TravelRequest: $e');
      rethrow;
    }
  }

  static int _parseKm(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) {
      final parsed = int.tryParse(value);
      if (parsed != null) return parsed;
      final parsedDouble = double.tryParse(value);
      if (parsedDouble != null) return parsedDouble.toInt();
    }
    return 0;
  }

  static DateTime _parseTimestamp(dynamic value) {
    if (value == null) {
      print('⚠️ Timestamp is null, using current time');
      return DateTime.now();
    }
    
    if (value is DateTime) return value;
    
    if (value is String) {
      try {
        return DateTime.parse(value);
      } catch (e) {
        print('⚠️ Failed to parse timestamp string: $value - $e');
        return DateTime.now();
      }
    }
    
    if (value is int) {
      try {
        // Handle both milliseconds and seconds since epoch
        if (value > 10000000000) {
          // Milliseconds
          return DateTime.fromMillisecondsSinceEpoch(value);
        } else {
          // Seconds
          return DateTime.fromMillisecondsSinceEpoch(value * 1000);
        }
      } catch (e) {
        print('⚠️ Failed to parse timestamp int: $value - $e');
        return DateTime.now();
      }
    }
    
    print('⚠️ Unknown timestamp format: $value (${value.runtimeType})');
    return DateTime.now();
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

  @override
  String toString() {
    return 'TravelRequest(id: $id, name: $name, km: $km, status: $status, timestamp: $timestamp)';
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
    // Your .NET API requires Status field with capital S
    return {
      'name': name,
      'km': km,
      'Status': 'pending',  // Capital S is required by your API
    };
  }

  @override
  String toString() {
    return 'CreateTravelRequest(name: $name, km: $km)';
  }
}
class TravelRequest {
  String id;
  String km;
  String client;
  String status;

  TravelRequest({
    required this.km,
    required this.client,
    required this.status,
  }) : id = DateTime.now().millisecondsSinceEpoch.toString();

  TravelRequest.withId({
    required this.id,
    required this.km,
    required this.client,
    required this.status,
  });

  Map<String, dynamic> toMap() => {
        "id": id,
        "km": km,
        "client": client,
        "status": status,
      };

  factory TravelRequest.fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return TravelRequest(
        km: "0",
        client: "Unknown",
        status: "Pending",
      );
    }

    return TravelRequest.withId(
      id: map["id"] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      km: map["km"] ?? "0",
      client: map["client"] ?? "Unknown",
      status: map["status"] ?? "Pending",
    );
  }
}
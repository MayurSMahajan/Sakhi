import 'dart:convert';

List<LatLong> latLongFromJson(String str) =>
    List<LatLong>.from(json.decode(str).map((x) => LatLong.fromJson(x)));

String latLongToJson(List<LatLong> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LatLong {
  LatLong({
    required this.lat,
    required this.long,
  });

  String lat;
  String long;

  factory LatLong.fromJson(Map<String, dynamic> json) => LatLong(
        lat: json["lat"],
        long: json["long"],
      );

  Map<String, dynamic> toJson() => {
        "lat": lat,
        "long": long,
      };
}

import 'package:gowheel_flutterflow_ui/url.dart';
import 'package:intl/intl.dart';

class User {
  String id;
  String name;
  String? license;
  String? image;
  String? cic;
  String? phoneNumber;
  double? longitude;
  double? latitude;
  int reportPoint;
  DateTime? birthday;
  List<String> roles;

  User({
    required this.id,
    required this.name,
    this.license,
    this.image,
    this.cic,
    this.phoneNumber,
    this.longitude,
    this.latitude,
    this.reportPoint = 0,
    this.birthday,
    required this.roles,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'].toString(),
      name: json['name'].toString(),
      license: json['license']?.toString(),
      image: json['image']?.toString(),
      cic: json['cic']?.toString(),
      phoneNumber: json['phoneNumber']?.toString(),
      longitude: json['longitude'] != null ? double.parse(json['longitude'].toString()) : null,
      latitude: json['latitude'] != null ? double.parse(json['latitude'].toString()) : null,
      reportPoint: json['reportPoint'] ?? 0,
      birthday: json['birthday'] != null ? DateTime.tryParse(json['birthday'].toString()) : null,
      roles: (json['roles'] as List<dynamic>?)?.map((role) => role.toString()).toList() ?? ['User'],
    );
  }

  String get formattedBirthday {
    return birthday != null
        ? DateFormat('dd/MM/yyyy').format(birthday!)
        : 'Not set';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'license': license,
      'image': image,
      'cic': cic,
      'phoneNumber': phoneNumber,
      'reportPoint': reportPoint,
      'birthday': birthday?.toIso8601String(),
      'roles': roles,
    };
  }

  String? get fullImageUrl => image != null && image!.isNotEmpty
      ? URL.imageUrl + image!
      : null;

  String? get fullCICUrl => cic != null && cic!.isNotEmpty
      ? URL.imageUrl + cic!
      : null;

  String? get fullLicenseUrl => license != null && license!.isNotEmpty
      ? URL.imageUrl + license!
      : null;
}
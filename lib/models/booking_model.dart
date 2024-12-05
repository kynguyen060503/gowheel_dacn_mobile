import 'post_model.dart';
import 'promotion_model.dart';
import 'user_model.dart';

class Booking {
  final int id;
  final String createdById;
  final DateTime createdOn;
  final DateTime? modifiedOn;
  final String? modifiedById;
  final bool isDeleted;
  final double prePayment;
  final double total;
  final double finalValue;
  final DateTime recieveOn;
  final DateTime returnOn;
  final String status;
  final bool isRequest;
  final bool isResponse;
  final String? longitude;
  final String? latitude;
  final bool isRequireDriver;
  final bool hasDriver;
  final bool isPay;
  final User user;
  final Post post;
  final Promotion? promotion;

  Booking({
    required this.id,
    required this.createdById,
    required this.createdOn,
    this.modifiedOn,
    this.modifiedById,
    this.isDeleted = false,
    required this.prePayment,
    required this.total,
    required this.finalValue,
    required this.recieveOn,
    required this.returnOn,
    required this.status,
    required this.isRequest,
    required this.isResponse,
    this.longitude,
    this.latitude,
    required this.isRequireDriver,
    required this.hasDriver,
    required this.isPay,
    required this.user,
    required this.post,
    this.promotion,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'] ?? 0,
      createdById: json['createdById'] ?? '',
      createdOn: DateTime.parse(json['createdOn'] ?? DateTime.now().toIso8601String()),
      modifiedOn: json['modifiedOn'] != null ? DateTime.parse(json['modifiedOn']) : null,
      modifiedById: json['modifiedById'],
      isDeleted: json['isDeleted'] ?? false,
      prePayment: (json['prePayment'] ?? 0).toDouble(),
      total: (json['total'] ?? 0).toDouble(),
      finalValue: (json['finalValue'] ?? 0).toDouble(),
      recieveOn: DateTime.parse(json['recieveOn'] ?? DateTime.now().toIso8601String()),
      returnOn: DateTime.parse(json['returnOn'] ?? DateTime.now().toIso8601String()),
      status: json['status'] ?? '',
      isRequest: json['isRequest'] ?? false,
      isResponse: json['isResponse'] ?? false,
      longitude: json['longitude'],
      latitude: json['latitude'],
      isRequireDriver: json['isRequireDriver'] ?? false,
      hasDriver: json['hasDriver'] ?? false,
      isPay: json['isPay'] ?? false,
      user: User.fromJson(json['user'] ?? {}),
      post: Post.fromJson(json['post'] ?? {}),
      promotion: json['promotion'] != null ? Promotion.fromJson(json['promotion']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdById': createdById,
      'createdOn': createdOn.toIso8601String(),
      'modifiedOn': modifiedOn?.toIso8601String(),
      'modifiedById': modifiedById,
      'isDeleted': isDeleted,
      'prePayment': prePayment,
      'total': total,
      'finalValue': finalValue,
      'recieveOn': recieveOn.toIso8601String(),
      'returnOn': returnOn.toIso8601String(),
      'status': status,
      'isRequest': isRequest,
      'isResponse': isResponse,
      'longitude': longitude,
      'latitude': latitude,
      'isRequireDriver': isRequireDriver,
      'hasDriver': hasDriver,
      'isPay': isPay,
      'user': user.toJson(),
      'post': post.toJson(),
      'promotion': promotion?.toJson(),
    };
  }
}
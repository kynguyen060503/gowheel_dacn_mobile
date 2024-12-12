import 'package:gowheel_flutterflow_ui/models/user_model.dart';

import 'post_model.dart';
import 'promotion_model.dart';

class DriverBooking {
  final int id;
  final double prePayment;
  final double total;
  final double finalValue;
  final DateTime recieveOn;
  final DateTime returnOn;
  final String status;
  final bool isRequest;
  final bool isResponse;
  final double? longitude;
  final double? latitude;
  final bool isRequireDriver;
  final bool hasDriver;
  final bool isPay;
  final User user;
  final Post post;
  final Promotion? promotion;
  final String createdById;
  final DateTime createdOn;
  final String? modifiedById;
  final DateTime? modifiedOn;
  final bool isDeleted;

  DriverBooking({
    required this.id,
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
    required this.createdById,
    required this.createdOn,
    this.modifiedById,
    this.modifiedOn,
    required this.isDeleted,
  });

  // Factory để parse từ JSON
  factory DriverBooking.fromJson(Map<String, dynamic> json) {
    return DriverBooking(
      id: json['id'],
      prePayment: json['prePayment'].toDouble(),
      total: json['total'].toDouble(),
      finalValue: json['finalValue'].toDouble(),
      recieveOn: DateTime.parse(json['recieveOn']),
      returnOn: DateTime.parse(json['returnOn']),
      status: json['status'],
      isRequest: json['isRequest'],
      isResponse: json['isResponse'],
      longitude: json['longitude'] != null ? double.parse(json['longitude']) : null,
      latitude: json['latitude'] != null ? double.parse(json['latitude']) : null,
      isRequireDriver: json['isRequireDriver'],
      hasDriver: json['hasDriver'],
      isPay: json['isPay'],
      user: User.fromJson(json['user']),
      post: Post.fromJson(json['post']),
      promotion: json['promotion'] != null ? Promotion.fromJson(json['promotion']) : null,
      createdById: json['createdById'],
      createdOn: DateTime.parse(json['createdOn']),
      modifiedById: json['modifiedById'],
      modifiedOn: json['modifiedOn'] != null ? DateTime.parse(json['modifiedOn']) : null,
      isDeleted: json['isDeleted'],
    );
  }

  // Chuyển thành JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
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
      'createdById': createdById,
      'createdOn': createdOn.toIso8601String(),
      'modifiedById': modifiedById,
      'modifiedOn': modifiedOn?.toIso8601String(),
      'isDeleted': isDeleted,
    };
  }
}
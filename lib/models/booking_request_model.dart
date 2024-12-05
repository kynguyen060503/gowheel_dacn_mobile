class BookingRequest {
  final double prePayment;
  final double total;
  final double finalValue;
  final DateTime recieveOn;
  final DateTime returnOn;
  final String longitude;
  final String latitude;
  final bool isRequireDriver;
  final int postId;
  final int? promotionId;
  final double discountValue;

  BookingRequest({
    required this.prePayment,
    required this.total,
    required this.finalValue,
    required this.recieveOn,
    required this.returnOn,
    required this.isRequireDriver,
    required this.postId,
    required this.longitude, // Sửa tại đây
    required this.latitude,  // Sửa tại đây
    this.promotionId,
    required this.discountValue,
  });

  Map<String, dynamic> toJson() {
    return {
      'prePayment': prePayment,
      'total': total,
      'finalValue': finalValue,
      'recieveOn': recieveOn.toIso8601String(),
      'returnOn': returnOn.toIso8601String(),
      'isRequireDriver': isRequireDriver,
      'longitude': longitude,  // Giữ lại longitude
      'latitude': latitude,    // Giữ lại latitude
      'postId': postId,
      'promotionId': promotionId,
      'discountValue': discountValue,
    };
  }
}

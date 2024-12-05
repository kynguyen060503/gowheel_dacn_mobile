class Invoice {
  final int id;
  final String createdById;
  final DateTime createdOn;
  final double prePayment;
  final double total;
  final bool isPay;
  final bool refundInvoice;
  final DateTime returnOn;
  final BookingInfo? booking;

  Invoice({
    required this.id,
    required this.createdById,
    required this.createdOn,
    required this.prePayment,
    required this.total,
    required this.isPay,
    required this.refundInvoice,
    required this.returnOn,
    this.booking,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) {
    try {
      return Invoice(
        id: json['id'] is int 
            ? json['id'] 
            : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
        createdById: json['createdById']?.toString() ?? '',
        createdOn: json['createdOn'] != null 
            ? DateTime.parse(json['createdOn']) 
            : DateTime.now(),
        prePayment: _parseDouble(json['prePayment']),
        total: _parseDouble(json['total']),
        isPay: json['isPay'] ?? false,
        refundInvoice: json['refundInvoice'] ?? false,
        returnOn: json['returnOn'] != null 
            ? DateTime.parse(json['returnOn']) 
            : DateTime.now(),
        booking: json['booking'] != null 
            ? BookingInfo.fromJson(json['booking']) 
            : null,
      );
    } catch (e) {
      print('Error parsing Invoice: $e');
      rethrow;
    }
  }

  // Helper method to safely parse doubles
  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is int) return value.toDouble();
    if (value is double) return value;
    return double.tryParse(value.toString()) ?? 0.0;
  }
}

// Simplified BookingInfo class with only essential fields
class BookingInfo {
  final int id;
  final String status;
  final DateTime recieveOn;
  final DateTime returnOn;
  final bool isRequireDriver;
  final bool hasDriver;
  final bool isPay;
  final UserInfo? user;

  BookingInfo({
    required this.id,
    required this.status,
    required this.recieveOn,
    required this.returnOn,
    required this.isRequireDriver,
    required this.hasDriver,
    required this.isPay,
    this.user,
  });

  factory BookingInfo.fromJson(Map<String, dynamic> json) {
    try {
      return BookingInfo(
        id: json['id'] is int 
            ? json['id'] 
            : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
        status: json['status']?.toString() ?? '',
        recieveOn: json['recieveOn'] != null 
            ? DateTime.parse(json['recieveOn']) 
            : DateTime.now(),
        returnOn: json['returnOn'] != null 
            ? DateTime.parse(json['returnOn']) 
            : DateTime.now(),
        isRequireDriver: json['isRequireDriver'] ?? false,
        hasDriver: json['hasDriver'] ?? false,
        isPay: json['isPay'] ?? false,
        user: json['user'] != null ? UserInfo.fromJson(json['user']) : null,
      );
    } catch (e) {
      print('Error parsing BookingInfo: $e');
      rethrow;
    }
  }
}

// Simplified UserInfo class with only essential fields
class UserInfo {
  final String id;
  final String name;
  final String? phoneNumber;
  final String? image;

  UserInfo({
    required this.id,
    required this.name,
    this.phoneNumber,
    this.image,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    try {
      return UserInfo(
        id: json['id']?.toString() ?? '',
        name: json['name']?.toString() ?? '',
        phoneNumber: json['phoneNumber']?.toString(),
        image: json['image']?.toString(),
      );
    } catch (e) {
      print('Error parsing UserInfo: $e');
      rethrow;
    }
  }
}
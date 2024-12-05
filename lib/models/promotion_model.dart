class Promotion {
  final int id;
  final bool isDeleted;
  final String content;
  final double discountValue;
  final String expiredDate;

  Promotion({
    required this.id,
    required this.isDeleted,
    required this.content,
    required this.discountValue,
    required this.expiredDate,
  });

  factory Promotion.fromJson(Map<String, dynamic> json) {
    return Promotion(
      id: json['id'] as int,
      isDeleted: json['isDeleted'] as bool,
      content: json['content'] as String,
      discountValue: json['discountValue'] is int
          ? (json['discountValue'] as int).toDouble()
          : json['discountValue'] as double,
      expiredDate: json['expiredDate'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'isDeleted': isDeleted,
      'content': content,
      'discountValue': discountValue,
      'expiredDate': expiredDate,
    }..removeWhere((key, value) => value == null);
  }
}
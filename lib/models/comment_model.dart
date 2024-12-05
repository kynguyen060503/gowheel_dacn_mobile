class Comment {
  final int id;
  final String createdById;
  final DateTime createdOn;
  final String? modifiedById;
  final DateTime? modifiedOn;
  final bool isDeleted;
  final String comment;
  final double point;
  final String? userName;
  final String? userImage;

  Comment({
    required this.id,
    required this.createdById,
    required this.createdOn,
    this.modifiedById,
    this.modifiedOn,
    required this.isDeleted,
    required this.comment,
    required this.point,
    this.userName,
    this.userImage,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      createdById: json['createdById'],
      createdOn: DateTime.parse(json['createdOn']),
      modifiedById: json['modifiedById'],
      modifiedOn: json['modifiedOn'] != null ? DateTime.parse(json['modifiedOn']) : null,
      isDeleted: json['isDeleted'],
      comment: json['comment'],
      point: json['point'],
      userName: json['userName'],
      userImage: json['userImage'],
    );
  }
}
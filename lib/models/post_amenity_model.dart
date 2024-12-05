class PostAmenity {
  int? id;
  int? postId;
  String? postName;
  int? amenityId;
  String? amenityName;
  bool? isDeleted;

  PostAmenity({
    this.id,
    this.postId,
    this.postName,
    this.amenityId,
    this.amenityName,
    this.isDeleted,
  });

  PostAmenity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    postId = json['postId'];
    postName = json['postName']?.toString();
    amenityId = json['amenityId'];
    amenityName = json['amenityName']?.toString();
    isDeleted = json['isDeleted'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'postId': postId,
      'postName': postName,
      'amenityId': amenityId,
      'amenityName': amenityName,
      'isDeleted': isDeleted,
    };
  }
}
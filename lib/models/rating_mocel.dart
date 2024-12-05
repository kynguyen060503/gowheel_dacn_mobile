class Rating {
  int? id;
  bool? isDeleted;
  String? comment;
  double? point;
  String? userName;
  String? userImage;

  Rating(
      {this.id,
        this.isDeleted,
        this.comment,
        this.point,
        this.userName,
        this.userImage});

  Rating.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isDeleted = json['isDeleted'];
    comment = json['comment'];
    point = json['point'];
    userName = json['userName'];
    userImage = json['userImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['isDeleted'] = this.isDeleted;
    data['comment'] = this.comment;
    data['point'] = this.point;
    data['userName'] = this.userName;
    data['userImage'] = this.userImage;
    return data;
  }
}
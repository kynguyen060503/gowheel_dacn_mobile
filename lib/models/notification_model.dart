import 'user_model.dart';

class Notification {
  int? id;
  String? title;
  String? content;
  String? createOn;
  bool? isRead;
  User? user;

  Notification(
      {this.id,
      this.title,
      this.content,
      this.createOn,
      this.isRead,
      this.user});

  Notification.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    content = json['content'];
    createOn = json['createOn'];
    isRead = json['isRead'];
    user = json['user'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['content'] = this.content;
    data['createOn'] = this.createOn;
    data['isRead'] = this.isRead;
    data['user'] = this.user;
    return data;
  }
}

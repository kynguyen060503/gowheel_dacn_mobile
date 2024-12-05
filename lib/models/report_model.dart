class Report {
  int? id;
  bool? isDeleted;
  String? name;

  Report({this.id, this.isDeleted, this.name});

  Report.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isDeleted = json['isDeleted'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['isDeleted'] = this.isDeleted;
    data['name'] = this.name;
    return data;
  }
}

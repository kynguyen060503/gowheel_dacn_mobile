class Amenity {
  final int id;
  final String createdById;
  final DateTime createdOn;
  final String? modifiedById;
  final DateTime? modifiedOn;
  final bool isDeleted;
  final String name;
  final String iconImage;

  Amenity({
    required this.id,
    required this.createdById,
    required this.createdOn,
    this.modifiedById,
    this.modifiedOn,
    required this.isDeleted,
    required this.name,
    required this.iconImage,
  });

  factory Amenity.fromJson(Map<String, dynamic> json) {
    return Amenity(
      id: json['id'],
      createdById: json['createdById'],
      createdOn: DateTime.parse(json['createdOn']),
      modifiedById: json['modifiedById'],
      modifiedOn: json['modifiedOn'] != null
          ? DateTime.parse(json['modifiedOn'])
          : null,
      isDeleted: json['isDeleted'],
      name: json['name'],
      iconImage: json['iconImage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdById': createdById,
      'createdOn': createdOn.toIso8601String(),
      'modifiedById': modifiedById,
      'modifiedOn': modifiedOn?.toIso8601String(),
      'isDeleted': isDeleted,
      'name': name,
      'iconImage': iconImage,
    };
  }
}
import 'package:gowheel_flutterflow_ui/models/post_amenity_model.dart';
import 'package:gowheel_flutterflow_ui/models/promotion_model.dart';
import 'package:gowheel_flutterflow_ui/models/rating_mocel.dart';
import 'package:gowheel_flutterflow_ui/models/user_model.dart';

class Post {
  int id;
  bool isDeleted;
  String name;
  String image;
  List<String>? images;
  String description;
  int seat;
  String rentLocation;
  bool hasDriver;
  double pricePerHour;
  double pricePerDay;
  bool gear;
  String fuel;
  double fuelConsumed;
  int? rideNumber;
  double? avgRating;
  bool isDisabled;
  int? carTypeId;
  String carTypeName;
  int? companyId;
  String companyName;
  User? user;
  List<PostAmenity> postAmenities;
  List<Promotion> postPromotion;
  List<Rating> ratings;

  Post({
    required this.id,
    required this.isDeleted,
    required this.name,
    required this.image,
    this.images,
    required this.description,
    required this.seat,
    required this.rentLocation,
    required this.hasDriver,
    required this.pricePerHour,
    required this.pricePerDay,
    required this.gear,
    required this.fuel,
    required this.fuelConsumed,
    this.rideNumber,
    this.avgRating,
    required this.isDisabled,
    this.carTypeId,
    required this.carTypeName,
    this.companyId,
    required this.companyName,
    this.user,
    required this.postAmenities,
    required this.postPromotion,
    required this.ratings,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    try {
      List<String>? imagesList;
      if (json['images'] != null) {
        imagesList = (json['images'] as List)
            .map((img) => img['url'] as String)
            .toList();
      }

      return Post(
        id: json['id'] as int,
        isDeleted: json['isDeleted'] as bool,
        name: json['name'].toString(),
        image: json['image'].toString(),
        images: imagesList,
        description: json['description'].toString(),
        seat: json['seat'] as int,
        rentLocation: json['rentLocation'].toString(),
        hasDriver: json['hasDriver'] as bool,
        pricePerHour: (json['pricePerHour'] as num).toDouble(),
        pricePerDay: (json['pricePerDay'] as num).toDouble(),
        gear: json['gear'] as bool,
        fuel: json['fuel'].toString(),
        fuelConsumed: (json['fuelConsumed'] as num).toDouble(),
        rideNumber: json['rideNumber'] as int?,
        avgRating: json['avgRating'] != null ? (json['avgRating'] as num).toDouble() : null,
        isDisabled: json['isDisabled'] as bool,
        carTypeId: json['carTypeId'] as int?,
        carTypeName: json['carTypeName'].toString(),
        companyId: json['companyId'] as int?,
        companyName: json['companyName'].toString(),
        user: json['user'] != null ? User.fromJson(json['user']) : null,
        postAmenities: json['postAmenities'] != null
            ? List<PostAmenity>.from(json['postAmenities'].map((x) => PostAmenity.fromJson(x)))
            : [],
        postPromotion: json['postPromotions'] != null
            ? List<Promotion>.from(json['postPromotions'].map((x) => Promotion.fromJson(x['promotion'])))
            : [],
        ratings: json['ratings'] != null
            ? List<Rating>.from(json['ratings'].map((x) => Rating.fromJson(x)))
            : [],
      );
    } catch (e) {
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'isDeleted': isDeleted,
      'name': name,
      'image': image,
      'images': images?.map((img) => {'url': img}).toList(),
      'description': description,
      'seat': seat,
      'rentLocation': rentLocation,
      'hasDriver': hasDriver,
      'pricePerHour': pricePerHour,
      'pricePerDay': pricePerDay,
      'gear': gear,
      'fuel': fuel,
      'fuelConsumed': fuelConsumed,
      'rideNumber': rideNumber,
      'avgRating': avgRating,
      'isDisabled': isDisabled,
      'carTypeId': carTypeId,
      'carTypeName': carTypeName,
      'companyId': companyId,
      'companyName': companyName,
      'user': user?.toJson(),
      'postAmenities': postAmenities.map((amenity) => amenity.toJson()).toList(),
      'postPromotions': postPromotion.map((promo) => {
        'promotion': promo.toJson()
      }).toList(),
      'ratings': ratings.map((rating) => rating.toJson()).toList(),
    };
  }
}
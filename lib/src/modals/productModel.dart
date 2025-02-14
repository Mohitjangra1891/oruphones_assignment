// To parse this JSON data, do
//
//     final productModel = productModelFromJson(jsonString);

import 'dart:convert';

ProductModel productModelFromJson(String str) => ProductModel.fromJson(json.decode(str));

String productModelToJson(ProductModel data) => json.encode(data.toJson());

class ProductModel {
  String id;
  String deviceCondition;
  String listedBy;
  String deviceStorage;
  List<Images> images;
  DefaultImage defaultImage;
  String listingState;
  String listingLocation;
  String listingLocality;
  String listingPrice;
  String make;
  String marketingName;
  bool openForNegotiation;
  bool verified;
  String listingId;
  String status;
  String verifiedDate;
  String listingDate;
  String deviceRam;
  String warranty;
  String imagePath;
  DateTime createdAt;
  DateTime updatedAt;
  Location location;

  ProductModel({
    required this.id,
    required this.deviceCondition,
    required this.listedBy,
    required this.deviceStorage,
    required this.images,
    required this.defaultImage,
    required this.listingState,
    required this.listingLocation,
    required this.listingLocality,
    required this.listingPrice,
    required this.make,
    required this.marketingName,
    required this.openForNegotiation,
    required this.verified,
    required this.listingId,
    required this.status,
    required this.verifiedDate,
    required this.listingDate,
    required this.deviceRam,
    required this.warranty,
    required this.imagePath,
    required this.createdAt,
    required this.updatedAt,
    required this.location,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
    id: json["_id"],
    deviceCondition: json["deviceCondition"],
    listedBy: json["listedBy"],
    deviceStorage: json["deviceStorage"],
    images: List<Images>.from(json["images"].map((x) => Images.fromJson(x))),
    defaultImage: DefaultImage.fromJson(json["defaultImage"]),
    listingState: json["listingState"],
    listingLocation: json["listingLocation"],
    listingLocality: json["listingLocality"],
    listingPrice: json["listingPrice"],
    make: json["make"],
    marketingName: json["marketingName"],
    openForNegotiation: json["openForNegotiation"],
    verified: json["verified"],
    listingId: json["listingId"],
    status: json["status"],
    verifiedDate: json["verifiedDate"],
    listingDate: json["listingDate"],
    deviceRam: json["deviceRam"],
    warranty: json["warranty"],
    imagePath: json["imagePath"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    location: Location.fromJson(json["location"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "deviceCondition": deviceCondition,
    "listedBy": listedBy,
    "deviceStorage": deviceStorage,
    "images": List<dynamic>.from(images.map((x) => x.toJson())),
    "defaultImage": defaultImage.toJson(),
    "listingState": listingState,
    "listingLocation": listingLocation,
    "listingLocality": listingLocality,
    "listingPrice": listingPrice,
    "make": make,
    "marketingName": marketingName,
    "openForNegotiation": openForNegotiation,
    "verified": verified,
    "listingId": listingId,
    "status": status,
    "verifiedDate": verifiedDate,
    "listingDate": listingDate,
    "deviceRam": deviceRam,
    "warranty": warranty,
    "imagePath": imagePath,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "location": location.toJson(),
  };
}

class DefaultImage {
  String fullImage;
  String id;

  DefaultImage({
    required this.fullImage,
    required this.id,
  });

  factory DefaultImage.fromJson(Map<String, dynamic> json) => DefaultImage(
    fullImage: json["fullImage"],
    id: json["_id"],
  );

  Map<String, dynamic> toJson() => {
    "fullImage": fullImage,
    "_id": id,
  };
}

class Images {
  String thumbImage;
  String fullImage;
  String isVarified;
  String option;
  String id;

  Images({
    required this.thumbImage,
    required this.fullImage,
    required this.isVarified,
    required this.option,
    required this.id,
  });

  factory Images.fromJson(Map<String, dynamic> json) => Images(
    thumbImage: json["thumbImage"] ?? "",
    fullImage: json["fullImage"] ?? "",
    isVarified: json["isVarified"] ?? "",
    option: json["option"] ??"",
    id: json["_id"]?? "",
  );

  Map<String, dynamic> toJson() => {
    "thumbImage": thumbImage,
    "fullImage": fullImage,
    "isVarified": isVarified,
    "option": option,
    "_id": id,
  };
}

class Location {
  String type;
  List<double> coordinates;
  String id;

  Location({
    required this.type,
    required this.coordinates,
    required this.id,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    type: json["type"],
    coordinates: List<double>.from(json["coordinates"].map((x) => x?.toDouble())),
    id: json["_id"],
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "coordinates": List<dynamic>.from(coordinates.map((x) => x)),
    "_id": id,
  };
}

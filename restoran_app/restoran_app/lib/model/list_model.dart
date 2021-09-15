class ListModelRestaurants {
  String id;
  String name;
  String description;
  String pictureId;
  String city;
  double rating;

  ListModelRestaurants({
    required this.id,
    required this.name,
    required this.description,
    required this.pictureId,
    required this.city,
    required this.rating,
  });

  factory ListModelRestaurants.fromJson(Map<String, dynamic> json) {
    return ListModelRestaurants(
        id: json["id"].toString(),
        name: json["name"].toString(),
        description: json["description"].toString(),
        pictureId: json["pictureId"].toString(),
        city: json["city"].toString(),
        rating: json["rating"].toDouble());
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "pictureId": pictureId,
        "city": city,
        "rating": rating
      };
}

class ListModel {
  bool error;
  List<ListModelRestaurants> restaurants;

  ListModel({
    required this.error,
    required this.restaurants,
  });

  factory ListModel.fromJson(Map<String, dynamic> json) {
    final v = json["restaurants"];
    final arr0 = <ListModelRestaurants>[];
    if (json["restaurants"] != null) {
      v.forEach((v) {
        arr0.add(ListModelRestaurants.fromJson(v));
      });
    }
    return ListModel(error: json["error"], restaurants: arr0);
  }

  Map<String, dynamic> toJson() => {
        "error": error,
        "restaurants": List<dynamic>.from(restaurants.map((x) => x.toJson())),
      };
}

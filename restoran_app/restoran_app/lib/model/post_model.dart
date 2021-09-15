class PostModelRestaurantCustomerReviews {
  String name;
  String review;
  String date;

  PostModelRestaurantCustomerReviews({
    required this.name,
    required this.review,
    required this.date,
  });

  factory PostModelRestaurantCustomerReviews.fromJson(
      Map<String, dynamic> json) {
    return PostModelRestaurantCustomerReviews(
      name: json["name"].toString(),
      review: json["review"].toString(),
      date: json["date"].toString(),
    );
  }
}

class PostModelRestaurantMenusDrinks {
  String name;

  PostModelRestaurantMenusDrinks({
    required this.name,
  });

  factory PostModelRestaurantMenusDrinks.fromJson(Map<String, dynamic> json) {
    return PostModelRestaurantMenusDrinks(name: json["name"].toString());
  }
}

class PostModelRestaurantMenusFoods {
  String name;

  PostModelRestaurantMenusFoods({
    required this.name,
  });

  factory PostModelRestaurantMenusFoods.fromJson(Map<String, dynamic> json) {
    return PostModelRestaurantMenusFoods(name: json["name"].toString());
  }
}

class PostModelRestaurantMenus {
  List<PostModelRestaurantMenusFoods> foods;
  List<PostModelRestaurantMenusDrinks> drinks;

  PostModelRestaurantMenus({
    required this.foods,
    required this.drinks,
  });

  factory PostModelRestaurantMenus.fromJson(Map<String, dynamic> json) {
    final x = json["foods"];
    final y = json["drinks"];
    final arr0 = <PostModelRestaurantMenusFoods>[];
    final arr1 = <PostModelRestaurantMenusDrinks>[];
    if (json["foods"] != null) {
      x.forEach((x) {
        arr0.add(PostModelRestaurantMenusFoods.fromJson(x));
      });
    }
    if (json["drinks"] != null) {
      y.forEach((y) {
        arr1.add(PostModelRestaurantMenusDrinks.fromJson(y));
      });
    }
    return PostModelRestaurantMenus(foods: arr0, drinks: arr1);
  }
}

class PostModelRestaurantCategories {
  String name;

  PostModelRestaurantCategories({
    required this.name,
  });

  factory PostModelRestaurantCategories.fromJson(Map<String, dynamic> json) {
    return PostModelRestaurantCategories(name: json["name"].toString());
  }
}

class PostModelRestaurant {
  String id;
  String name;
  String description;
  String city;
  String address;
  String pictureId;
  List<PostModelRestaurantCategories> categories;
  PostModelRestaurantMenus menus;
  double rating;
  List<PostModelRestaurantCustomerReviews> customerReviews;

  PostModelRestaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.city,
    required this.address,
    required this.pictureId,
    required this.categories,
    required this.menus,
    required this.rating,
    required this.customerReviews,
  });

  factory PostModelRestaurant.fromJson(Map<String, dynamic> json) {
    final x = json["categories"];
    final arr1 = <PostModelRestaurantCategories>[];
    if (json["categories"] != null) {
      x.forEach((x) {
        arr1.add(PostModelRestaurantCategories.fromJson(x));
      });
    }

    final v = json["customerReviews"];
    final arr0 = <PostModelRestaurantCustomerReviews>[];
    if (json["customerReviews"] != null) {
      v.forEach((v) {
        arr0.add(PostModelRestaurantCustomerReviews.fromJson(v));
      });
    }
    return PostModelRestaurant(
        id: json["id"].toString(),
        name: json["name"].toString(),
        description: json["description"].toString(),
        city: json["city"].toString(),
        address: json["address"].toString(),
        pictureId: json["pictureId"].toString(),
        categories: arr1,
        menus: PostModelRestaurantMenus.fromJson(json["menus"]),
        rating: json["rating"].toDouble(),
        customerReviews: arr0);
  }
}

class PostModel {
  bool error;
  String message;
  PostModelRestaurant restaurant;

  PostModel({
    required this.error,
    required this.message,
    required this.restaurant,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
        error: json["error"],
        message: json["message"].toString(),
        restaurant: PostModelRestaurant.fromJson(json["restaurant"]));
  }
}

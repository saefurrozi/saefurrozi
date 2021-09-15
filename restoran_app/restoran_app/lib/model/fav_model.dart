class Fav {
  late String id;
  late String name;
  late String city;
  late String pictureId;

  Fav(
      {required this.id,
      required this.name,
      required this.city,
      required this.pictureId});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'city': city, 'pictureId': pictureId};
  }

  Fav.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    city = map['city'];
    pictureId = map['pictureId'];
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:restoran_app/common/navigation.dart';
import 'package:restoran_app/provider/post_data_provider.dart';
import 'package:restoran_app/provider/db_provider.dart';
import 'package:restoran_app/model/fav_model.dart';

var informationTextStyle = TextStyle(fontFamily: 'Oxygen');

class DetailScreen extends StatefulWidget {
  static const routeName = '/resto_detail';
  final String restoId;

  const DetailScreen({required this.restoId});

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    final postMdl = Provider.of<PostDataProvider>(context, listen: false);
    postMdl.getPostData(context, widget.restoId);
    Provider.of<DbProvider>(context, listen: false)
        .getFavById(widget.restoId)
        .then((value) {
      if (value.id.isNotEmpty) {
        setState(() {
          isFavorite = true;
        });
      }
    }).catchError((e) {
      setState(() {
        isFavorite = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 1.0;
    final postMdl = Provider.of<PostDataProvider>(context);
    return Scaffold(
        body: postMdl.loading
            ? Center(
                child: CircularProgressIndicator(backgroundColor: Colors.red))
            : (postMdl.error == true
                ? Center(
                    child: Text(
                    "No Connection",
                  ))
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            Hero(
                              tag: 'theHero${widget.restoId}',
                              child: Image.network(
                                  "https://restaurant-api.dicoding.dev/images/medium/" +
                                      postMdl.post.restaurant.pictureId),
                            ),
                            SafeArea(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.grey,
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.arrow_back,
                                          color: Colors.white,
                                        ),
                                        onPressed: () {
                                          Navigation.back();
                                        },
                                      ),
                                    ),
                                    FavoriteButton(
                                        id: postMdl.post.restaurant.id,
                                        name: postMdl.post.restaurant.name,
                                        city: postMdl.post.restaurant.city,
                                        pictureId:
                                            postMdl.post.restaurant.pictureId,
                                        isFav: isFavorite),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 16.0),
                          child: Text(
                            postMdl.post.restaurant.name,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 35.0,
                              fontFamily: 'GreatVibes',
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Icon(Icons.place),
                                  SizedBox(height: 8.0),
                                  Text(
                                    postMdl.post.restaurant.city,
                                    style: informationTextStyle,
                                  ),
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Icon(Icons.star),
                                  SizedBox(height: 8.0),
                                  Text(
                                    postMdl.post.restaurant.rating.toString(),
                                    style: informationTextStyle,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            postMdl.post.restaurant.description,
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              fontSize: 16.0,
                              fontFamily: 'Oxygen',
                            ),
                          ),
                        ),
                        Container(
                          color: Colors.teal,
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            "\u{1F35B} MAKANAN",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20.0,
                                fontFamily: 'Staatliches',
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          height: 200,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Card(
                                clipBehavior: Clip.antiAlias,
                                child: Column(children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                        postMdl.post.restaurant.menus.foods
                                            .elementAt(index)
                                            .name
                                            .toString(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontStyle: FontStyle.italic)),
                                  ),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(30),
                                    child: Image.asset(
                                      'images/food.png',
                                      fit: BoxFit.fill,
                                      height: 100,
                                      width: 100,
                                    ),
                                  ),
                                ]),
                              );
                            },
                            itemCount:
                                postMdl.post.restaurant.menus.foods.length,
                          ),
                        ),
                        Container(
                          color: Colors.teal,
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            "\u{1F378} MINUMAN",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20.0,
                                fontFamily: 'Staatliches',
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          height: 200,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Card(
                                clipBehavior: Clip.hardEdge,
                                child: Column(children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                        postMdl.post.restaurant.menus.drinks
                                            .elementAt(index)
                                            .name
                                            .toString(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontStyle: FontStyle.italic)),
                                  ),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(30),
                                    child: Image.asset(
                                      'images/drink.png',
                                      fit: BoxFit.fitHeight,
                                      height: 100,
                                      width: 100,
                                    ),
                                  ),
                                ]),
                              );
                            },
                            itemCount:
                                postMdl.post.restaurant.menus.drinks.length,
                          ),
                        ),
                        Container(
                          color: Colors.teal,
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            "\u{1F4AC} REVIEW",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20.0,
                                fontFamily: 'Staatliches',
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          height: 200,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Align(
                                  child: SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: Card(
                                        clipBehavior: Clip.hardEdge,
                                        child: Column(children: [
                                          Padding(
                                            padding: const EdgeInsets.all(20.0),
                                            child: Text(
                                                postMdl.post.restaurant
                                                    .customerReviews
                                                    .elementAt(index)
                                                    .name,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontStyle: FontStyle.normal,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Text(
                                                '"' +
                                                    postMdl.post.restaurant
                                                        .customerReviews
                                                        .elementAt(index)
                                                        .review +
                                                    '"'.toString(),
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontStyle:
                                                        FontStyle.italic)),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Text(
                                                postMdl.post.restaurant
                                                    .customerReviews
                                                    .elementAt(index)
                                                    .date,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    fontStyle:
                                                        FontStyle.normal)),
                                          ),
                                        ]),
                                      )));
                            },
                            itemCount:
                                postMdl.post.restaurant.customerReviews.length,
                          ),
                        ),
                      ],
                    ),
                  )));
  }
}

class FavoriteButton extends StatefulWidget {
  final String id;
  final String name;
  final String city;
  final String pictureId;
  final bool isFav;

  const FavoriteButton(
      {required this.id,
      required this.name,
      required this.city,
      required this.pictureId,
      required this.isFav});

  @override
  _FavoriteButtonState createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  bool isFavorite = false;
  bool isFirst = true;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isFirst
            ? (widget.isFav ? Icons.favorite : Icons.favorite_border)
            : (isFavorite ? Icons.favorite : Icons.favorite_border),
        color: Colors.red,
      ),
      onPressed: () {
        setState(() {
          if (isFirst) isFavorite = widget.isFav;
          isFirst = false;
          isFavorite = !isFavorite;
          if (isFavorite) {
            final fav = Fav(
                id: widget.id,
                name: widget.name,
                city: widget.city,
                pictureId: widget.pictureId);

            Provider.of<DbProvider>(context, listen: false).addFav(fav);
          } else {
            Provider.of<DbProvider>(context, listen: false)
                .deleteFav(widget.id);
          }
        });
        if (isFavorite)
          _showToast(context, "Add to Favorite");
        else
          _showToast(context, "Remove from Favorite");
      },
    );
  }

  void _showToast(BuildContext context, String info) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(info),
        action: SnackBarAction(
            label: 'CLOSE', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }
}

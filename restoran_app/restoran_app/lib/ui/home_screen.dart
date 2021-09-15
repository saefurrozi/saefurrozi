import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restoran_app/ui/detail_screen.dart';
import 'package:restoran_app/provider/list_data_provider.dart';
import 'package:restoran_app/provider/db_provider.dart';
import 'package:restoran_app/model/fav_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:restoran_app/provider/scheduling_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../common/navigation.dart';
import '../helper/notification_helper.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/resto_home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final NotificationHelper _notificationHelper = NotificationHelper();
  static const String reminderPrefs = 'reminderFlag';
  bool isSwitched = false;

  @override
  void initState() {
    super.initState();
    _notificationHelper
        .configureSelectNotificationSubject(DetailScreen.routeName);
    _loadStatus();
  }

  @override
  void dispose() {
    selectNotificationSubject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final favs = Provider.of<DbProvider>(context, listen: false).favlist;
    final scheduled = Provider.of<SchedulingProvider>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.favorite),
              onPressed: () {
                Future.delayed(Duration.zero, () => showAlert(context, favs));
              },
            ),
            new PopupMenuButton(
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Switch(
                          value: isSwitched,
                          onChanged: (value) {
                            scheduled.scheduledInfo(value);
                            setState(() {
                              isSwitched = value;
                              _saveStatus(isSwitched);
                              if (scheduled.isScheduled)
                                _showToast(
                                    context, "Reminder Activated at 11:00 AM");
                              else
                                _showToast(context, "Reminder Disabled");
                            });
                            Navigator.pop(context);
                          }),
                      Text("Daily Reminder"),
                    ],
                  ),
                ),
              ],
            ),
          ],
          title: Text(
            "D' Restaurant",
            style: TextStyle(
                fontFamily: 'GreatVibes',
                fontSize: 28,
                fontWeight: FontWeight.bold),
          ),
          centerTitle: false,
          backgroundColor: Colors.teal,
        ),
        body: HomeList());
  }

  void _loadStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isSwitched = prefs.getBool(reminderPrefs) ?? false;
    });
  }

  void _saveStatus(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(reminderPrefs, value);
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

  void showAlert(BuildContext context, List<Fav> favs) {
    favs = Provider.of<DbProvider>(context, listen: false).favlist;
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.teal.shade900,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
          elevation: 16,
          child: Container(
            height: MediaQuery.of(context).size.height / 1.5,
            width: MediaQuery.of(context).size.width,
            child: Column(children: <Widget>[
              SizedBox(height: 20),
              Center(
                  child: Text(
                'Favorite',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              )),
              SizedBox(height: 20),
              Container(
                  height: MediaQuery.of(context).size.height / 2,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.teal.shade400,
                  child: favs.isEmpty
                      ? _buildRow(context, '', '', '', '')
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: favs.length,
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              onTap: () {
                                Navigator.pop(context);
                                Navigation.intentWithData(
                                    DetailScreen.routeName, favs[index].id);
                              },
                              child: _buildRow(
                                  context,
                                  favs[index].pictureId,
                                  favs[index].name,
                                  favs[index].city,
                                  favs[index].id),
                            );
                          })),
            ]),
          ),
        );
      },
    );
  }

  Widget _buildRow(BuildContext context, String imageAsset, String name,
      String city, String id) {
    return name.isEmpty
        ? Center(child: Text("List Empty"))
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: <Widget>[
                SizedBox(height: 12),
                Row(
                  children: <Widget>[
                    CircleAvatar(
                      child: CachedNetworkImage(
                        fit: BoxFit.fitHeight,
                        height: 50,
                        imageUrl:
                            'https://restaurant-api.dicoding.dev/images/small/' +
                                imageAsset,
                        placeholder: (context, url) =>
                            new CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            new Icon(Icons.restaurant),
                      ),
                    ),
                    SizedBox(width: 12),
                    Text(name),
                    Spacer(),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.yellow[900],
                          borderRadius: BorderRadius.circular(20)),
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 2),
                      child: Text(
                        '$city',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Container(height: 2, color: Colors.redAccent),
                SizedBox(height: 12),
              ],
            ),
          );
  }
}

class HomeList extends StatefulWidget {
  @override
  _HomeListState createState() => _HomeListState();
}

class _HomeListState extends State {
  TextEditingController editingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final postMd = Provider.of<ListDataProvider>(context, listen: false);
    postMd.getPostData(context, "", true);
  }

  @override
  Widget build(BuildContext context) {
    final postMd = Provider.of<ListDataProvider>(context);
    return Container(
        child: Column(children: <Widget>[
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          onSubmitted: (value) {
            postMd.getPostData(context, value, false);
          },
          controller: editingController,
          decoration: InputDecoration(
              labelText: "Search",
              hintText: "Search",
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)))),
        ),
      ),
      Expanded(
          child: postMd.loading
              ? Center(
                  child: CircularProgressIndicator(backgroundColor: Colors.red))
              : (postMd.error == true
                  ? Center(
                      child: Text(
                      "No Connection",
                    ))
                  : (postMd.post.restaurants.length == 0
                      ? Center(
                          child: Text(
                          "Empty",
                        ))
                      : ListView.builder(
                          itemBuilder: (context, index) {
                            return InkWell(
                                onTap: () async {
                                  String restoId = postMd.post.restaurants
                                      .elementAt(index)
                                      .id;
                                  Navigation.intentWithData(
                                      DetailScreen.routeName, restoId);
                                },
                                child: Hero(
                                  tag:
                                      'theHero${postMd.post.restaurants.elementAt(index).id}',
                                  child: Card(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Expanded(
                                          flex: 1,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            child: Image.network(
                                              "https://restaurant-api.dicoding.dev/images/small/" +
                                                  postMd.post.restaurants
                                                      .elementAt(index)
                                                      .pictureId,
                                              fit: BoxFit.fitHeight,
                                              height: 100,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Text(
                                                  postMd.post.restaurants
                                                      .elementAt(index)
                                                      .name,
                                                  style: TextStyle(
                                                      fontSize: 14.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily:
                                                          'Staatliches'),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  "\u{1F4CD} " +
                                                      postMd.post.restaurants
                                                          .elementAt(index)
                                                          .city,
                                                  style: TextStyle(
                                                      fontSize: 12.0,
                                                      fontFamily: "Staatliches",
                                                      fontStyle:
                                                          FontStyle.italic),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ));
                          },
                          itemCount: postMd.post.restaurants.length,
                        ))))
    ]));
  }
}

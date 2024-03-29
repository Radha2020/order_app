import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
//import 'package:geocoding/geocoding.dart';
//import 'package:flutter/services.dart';
import 'dart:io';
import 'package:shimmer/shimmer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:order_app/auth/login.dart';
import 'package:order_app/auth/registration.dart';
import 'package:order_app/DBHelp.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
//import 'dart:io';
import 'package:order_app/model/category.dart';
import 'package:order_app/model/mybanner.dart';
import 'package:order_app/services/Services.dart';
import 'package:order_app/page/product_details.dart';
import 'package:order_app/page/profile_page.dart';

import 'package:order_app/page/viewcart.dart';
import 'package:order_app/page/emptycart.dart';
//import 'package:geolocator/geolocator.dart';

import 'package:order_app/model/items.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => MyApp(),
      '/second': (context) => SecondPage(),
      '/home': (context) => MyApp(),
      '/login': (context) => LoginPage(),
      '/register': (context) => SecondPage(),
    },
  ));
}

class MyApp extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<MyApp> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final dbHelper = DBHelp.instance;
  String username = '';
  String email = '';
  String Address = 'search';
  String _categoryid;
  String _category;
  int _counter;
  List<Items> items = List();
  List<Items> filtereditems = List();
  bool _enabled = true;
  List<Category> categoryList = [];
  List<MyBanner> bannerList = [];
  bool isLoading;
  void initState() {
    isLoading = true;
    super.initState();

    checkcart();
    Future.delayed(Duration(seconds: 5)).then((value) {
      Services.fetchCategory().then((categoriesFromServer) {
        setState(() {
          categoryList = categoriesFromServer;
          print(categoryList.length);
          _category = "All";
          isLoading = false;
          //_enabled = false;
        });
      });
      // });

      Services.fetchBanner().then((bannersFromServer) {
        setState(() {
          bannerList = bannersFromServer;
          print(bannerList.length);
          isLoading = false;
        });
      });
    });
  }

  checkcart() async {
    var count =
        await dbHelper.queryRowCount().then((value) => _counter = value);
    // _calcTotal();
    setState(() {
      _counter = _counter;
    });
    print(_counter);
  }

  void checkRegister() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    print(prefs.getString('email'));

    if (prefs.getString('email') == null) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => SecondPage()));
    } else {
      return;
    }
  }

  /* void getMessage() {
    _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                content: ListTile(
                  title: Text(message['notification']['title']),
                  subtitle: Text(message['notification']['body']),
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Ok'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ));

      //      print('on message $message');
      //        setState(() => _message = message["notification"]["title"]);
//print(_message);
    }, onResume: (Map<String, dynamic> message) async {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                content: ListTile(
                  title: Text(message['notification']['title']),
                  subtitle: Text(message['notification']['body']),
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Ok'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ));

//          print('on resume $message');
      //    setState(() => _message = message["notification"]["title"]);
      //  print(_message);
    }, onLaunch: (Map<String, dynamic> message) async {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                content: ListTile(
                  title: Text(message['notification']['title']),
                  subtitle: Text(message['notification']['body']),
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Ok'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ));

      //print('on launch $message');
      //setState(() => _message = message["notification"]["title"]);
      // print(_message);
    });
  }
*/
  _getcred() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      //log=(prefs.getBool('login'));
      username = (prefs.getString('name'));
      print(username);
      email = (prefs.getString('email'));
      print(email);
      if (username == null) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      }
    });
  }

  /*_closecred() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.remove('name');
      prefs.remove('password');
      prefs.remove('waiterno');
      prefs.remove('waitername');
      dbHelper.deleteall();
      dbHelper.deletetable();
    });
  }*/

  /*Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Are you sure?'),
            content: Text('Do you want to exit an App'),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('No'),
              ),
              FlatButton(
                onPressed: () => exit(0),
                //Navigator.of(context).pop(true),
                child: Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
  }*/

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          exit(0);
        },
        child: Scaffold(
          appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              centerTitle: true,
              title: Column(
                children: [
                  SizedBox(height: 50),
                  Text("Store",
                      style: Theme.of(context)
                          .textTheme
                          .headline5
                          .copyWith(color: Colors.redAccent)),
                  Divider(),
                ],
              )),
          bottomNavigationBar: new BottomNavigationBar(
              // currentIndex: 0, // this will be set when a new tab is tapped

              backgroundColor: Colors.white,
              selectedFontSize: 1.0,
              unselectedFontSize: 1.0,
              type: BottomNavigationBarType.fixed,
              items: [
                BottomNavigationBarItem(
                    icon: new Stack(
                      children: <Widget>[
                        IconButton(
                          icon: new Icon(Icons.shopping_cart),
                          color: Colors.brown,
                          onPressed: () {
                            if (_counter == 0) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EmptyCart()));
                            } else {
//                        loadData(selectedtableno);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ViewCart()));

                              setState(() {
                                //  selectedWidgetMarker=WidgetMarker.third;
                              });
                            }
                          },
                        ),
                        // new Icon(Icons.shopping_cart,size:35,color: Colors.brown,),
                        _counter != 0 && _counter != null
                            ? new Positioned(
                                right: 0,
                                child: new Container(
                                  padding: EdgeInsets.all(1),
                                  decoration: new BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  constraints: BoxConstraints(
                                    minWidth: 12,
                                    minHeight: 12,
                                  ),
                                  child: new Text(
                                    '$_counter',
                                    style: new TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              )
                            : new Positioned(
                                right: 0,
                                child: new Container(),
                              )
                      ],
                    ),
                    label: ''
                    //title: Text('Home'),
                    ),
                BottomNavigationBarItem(
                    icon: new Stack(children: <Widget>[
                      IconButton(
                        icon: new Icon(Icons.search),
                        color: Colors.black,
                        onPressed: () {
                          // menuscreen();
                        },
                        //loadData();
                      ),
                    ]),
                    label: ''
                    // title: Text(''),
                    ),
                BottomNavigationBarItem(
                    icon: new Stack(children: <Widget>[
                      IconButton(
                        icon: new Icon(Icons.person),
                        color: Colors.black,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProfilePage()));
                          //  menuscreen();
                        },
                        //loadData();
                      ),
                    ]),
                    label: ''
                    //  title: Text(''),
                    ),
              ]),
          body:
              //SingleChildScrollView(
              Padding(
            padding: EdgeInsets.all(8.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: []),
              SizedBox(height: 20),
              Text(
                "Category",
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    .copyWith(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              // isLoading
              //   ? const Center(child: CircularProgressIndicator())
              /*Container(
                      height: 115,
                      child: ListView.builder(
                          itemCount: categoryList.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          //physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Column(children: [
                              Container(
                                padding: EdgeInsets.all(17),
                                margin: EdgeInsets.only(
                                    top: 5, bottom: 2, left: 7, right: 5),
                                height: 90,
                                width: 90,
                                child: CircleAvatar(
                                  backgroundColor: Colors.blue,
                                  radius: 70.0,
                                ),
                              ),
                              Text(categoryList[index].title,
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle2
                                      .copyWith(fontWeight: FontWeight.bold))
                            ]);
                          }))*/

              Container(
                  height: 115,
                  child: ListView.builder(
                      itemCount: categoryList.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      //physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Column(children: [
                          Container(
                            padding: EdgeInsets.all(17),
                            margin: EdgeInsets.only(
                                top: 5, bottom: 2, left: 7, right: 5),
                            height: 90,
                            width: 90,
                            child: InkWell(
                                onTap: () async {
                                  print("image clicked");
                                  _categoryid = categoryList[index].catid;
                                  _category = categoryList[index].title;
                                  Services.fetchProductsPerId(_categoryid)
                                      .then((categoriesFromServer) {
                                    setState(() {
                                      bannerList = categoriesFromServer;
                                      print(bannerList.length);
                                    });
                                  }); /*setState(() {
                                _categoryid = categoryList[index]
                                    .catid; //if you want to assign the index somewhere to check
                              });*/
                                },
                                child: CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  radius: 70.0,
                                  backgroundImage: NetworkImage(
                                    categoryList[index].imageUrl,
                                  ),
                                )),
                          ),
                          Text(categoryList[index].title,
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle2
                                  .copyWith(fontWeight: FontWeight.bold))
                        ]);
                      })),
              SizedBox(height: 30),
              Row(children: <Widget>[
                new RaisedButton(
                  child: new Text('All Items'),
                  onPressed: () {
                    setState(() {
                      Services.fetchCategory().then((categoriesFromServer) {
                        setState(() {
                          categoryList = categoriesFromServer;
                          print(categoryList.length);
                          _category = "All";
                          //_enabled = false;
                        });
                      });

                      Services.fetchBanner().then((bannersFromServer) {
                        setState(() {
                          bannerList = bannersFromServer;
                          print(bannerList.length);
                        });
                      });
                    });
                  },
                ),
              ]),
              _category != null
                  ? Text(
                      '$_category',
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          .copyWith(fontWeight: FontWeight.bold, fontSize: 18),
                    )
                  : Text(''),
              Expanded(
                child: ListView.builder(
                    padding: EdgeInsets.all(10.0),
                    itemCount: bannerList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        elevation: 4,
                        child: Container(
                          padding: EdgeInsets.all(6),
                          child: Row(
                            children: <Widget>[
                              Container(
                                  height: 110,
                                  width: 90,
                                  child: Image.network(
                                    bannerList[index].imageUrl,
                                    // 'https://placeimg.com/250/250/any',
                                    fit: BoxFit.cover,
                                  )),
                              SizedBox(
                                width: 5.0,
                              ),
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    MergeSemantics(
                                      child: Row(
                                        children: <Widget>[
                                          Icon(
                                            Icons.crop_square,
                                            color: Colors.red,
                                            size: 18,
                                          ),
                                          Flexible(
                                            child: Text(
                                              '${bannerList[index].title}',
                                              overflow: TextOverflow.ellipsis,
                                              softWrap: true,
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      'Several types are available.',
                                      maxLines: 1,
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey),
                                    ),
                                    SizedBox(height: 15),
                                    SizedBox(
                                        width: 75, // <-- Your width
                                        height: 30,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        Product_detailsPage(
                                                            title: bannerList[
                                                                    index]
                                                                .title)));
                                          },
                                          child: Text('Buy'),
                                          style: ElevatedButton.styleFrom(
                                            primary: Colors.amber,
                                            //change background color of button
                                            onPrimary: Colors
                                                .black, //change text color of button
                                          ),
                                        ))
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );

                      /* return Card(
                    child: Padding(
                  padding: EdgeInsets.all(25.0),
                  child: new ListTile(
                      title: Text('${bannerList[index].title}'),
                      subtitle: Row(
                        children: <Widget>[

                          Text('Rs:'),
                          Text('${bannerList[index].title}'),
                        ],
                      ),
                      leading: Text('${bannerList[index].title}'),
                      // ),
                      trailing:
                          // code=snapshot.data[index].code
                          Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                            IconButton(
                              icon: new Icon(Icons.remove),
                              onPressed: () {
                                setState(() {});
                              },
                              color: Colors.green,
                            ),
                            // Text(filtereditems[index]
                            //   .counter
                            // .toString()),
                            IconButton(
                              icon: new Icon(Icons.add),
                              onPressed: () {
                                setState(() {});
                              },
                              color: Colors.green,
                            )
                          ])),
                ));
             
             
             */
                    }),
              ),

              /*for (int i = 0; i < bannerList.length; i++) ...{
            Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.shade300,
                          spreadRadius: 5,
                          blurRadius: 5)
                    ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 220,
                      margin: EdgeInsets.only(bottom: 5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                          image: DecorationImage(
                            image: NetworkImage(bannerList[i].imageUrl),
                            fit: BoxFit.cover,
                          )),
                    ),
                    Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          bannerList[i].title,
                          style: Theme.of(context).textTheme.headline6.copyWith(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        )),
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          children: [
                            Icon(Icons.star, color: Colors.green),
                            Text("4.5", style: TextStyle(color: Colors.green)),
                            Text("(128 Ratings)",
                                style: TextStyle(color: Colors.green)),
                            Spacer(),
                            Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: Text("Western Food")),
                            Text("\$50", style: TextStyle(color: Colors.green)),
                          ],
                        )),
                    SizedBox(
                      height: 10,
                    )
                  ],
                ))
          }*/
            ]),
          ),
        ));
  }
}

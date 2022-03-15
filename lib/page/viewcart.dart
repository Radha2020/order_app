//import 'dart:html';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:order_app/main.dart';
import 'dart:async';
import 'package:order_app/DBprovider.dart';
import 'package:order_app/model/cart.dart';
import 'package:order_app/page/emptycart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:order_app/auth/registration.dart';

import 'package:order_app/auth/registration.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ViewCart(),
    );
  }
}

class ViewCart extends StatefulWidget {
  // final String tableno;
  // ViewCart({Key key, @required this.tableno}) : super(key: key);
  @override
  ViewCartState createState() => ViewCartState();
}

class ViewCartState extends State<ViewCart> {
  final dbHelper = DBprovider.instance;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Cart> cart = [];
  int _total;
  int _gtotal;
  int qty;
  String code;
  String itemcode;
  String tableno = "";
  int price;
  int tot;
  int id;
  int count;
  String desc;
  int _lastrowid;
  int tableid;
  @override
  void initState() {
    super.initState();
    // print("second screen");
    // print(widget.tableno);
    setState(() {
      //   tableno = widget.tableno;
    });
    _loaddata();
    _deliverycharge();
    _calcTotal();
  }

  Future<List<Cart>> _loaddata() async {
    print("loaddata calling");
    final Rows = await dbHelper.queryDetails();
    print('query item details :');
    Rows.forEach((row) => print(row));
    cart.clear();
    //  print(Rows);
    Rows.forEach((row) => cart.add(Cart.fromMap(row)));
    print(cart.length);

    if (cart.length == 0) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => EmptyCart()));
    } else {
      return cart;
    }
  }

/*
  menuscreen() async {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => MenuPage(tableno: tableno)));
//    Navigator.pop(context);
  }
*/
  add(desc, qty, price) async {
    print("desc");
    print(desc);
    var quantity = qty + 1;
    var total = quantity * price;
    print(total);
    Map<String, dynamic> row = {
      DBprovider.columnDesc: desc,
      DBprovider.columnQuantity: quantity,
      DBprovider.columnTotal: total,
    };
    dbHelper.update(row, desc);
    setState(() {
      _loaddata();
      _calcTotal();
    });
    final allRows = await dbHelper.queryAllRows();
    print('query all rows:');
    allRows.forEach((row) => print(row));
  }

  minus(desc, qty, price) async {
    print("desc,qty,price");
    print(desc);
    print(qty);
    print(price);
    var quantity = qty - 1;
    var total = quantity * price;
    print(total);
    Map<String, dynamic> row = {
      DBprovider.columnDesc: desc,
      DBprovider.columnQuantity: quantity,
      DBprovider.columnTotal: total,
    };
    dbHelper.update(row, desc);
    setState(() {
      _loaddata();
      _calcTotal();
    });
  }

  void _calcTotal() async {
    //get tableid per tableno
    var total = await dbHelper.calculateTotal().then((value) => _total = value);
    print("total");
    print(total);
    if (_total != null) {
      _gtotal = _total + 25;
    } else {
      _gtotal = 0;
    }
    setState(() {
      _total = _total;
      _gtotal = _gtotal;
    });
    print(total);
    setState(() {
      _total = _total;
    });
  }

  void _deliverycharge() {}
  del(id) async {
    print("id:");
    print(id);
    var res = await dbHelper.delete(id).then((value) => count = value);
    setState(() {
      _loaddata();
      _calcTotal();
    });
  }

  checkRegister() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getString('name'));
    if (prefs.getString('name') == null) {
      final snackBar = SnackBar(
          backgroundColor: Colors.red, content: Text("please Register"));
      ScaffoldMessenger.of(_scaffoldKey.currentContext).showSnackBar(snackBar);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => SecondPage()));
    } else {
      print("else part ");
      final snackBar = SnackBar(
          backgroundColor: Colors.red,
          content: Text("pls Complete Profile Details"));

      ScaffoldMessenger.of(_scaffoldKey.currentContext).showSnackBar(snackBar);
      //  Navigator.push(context,
      //    MaterialPageRoute(builder: (context) => CompleteProfilePage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        // backgroundColor: Colors.lightGreen,
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            centerTitle: true,
            iconTheme: IconThemeData(color: Colors.black),
            title: Column(
              // crossAxisAlignment: CrossAxisAlignment.s.start,
              children: [
                Text("Order Details",
                    style: Theme.of(context)
                        .textTheme
                        .headline5
                        .copyWith(color: Colors.blueGrey)),
              ],
            )),
        body: SingleChildScrollView(
            padding: EdgeInsets.all(10),
            child: Column(children: <Widget>[
              Container(
                padding: EdgeInsets.all(10),
                child: FutureBuilder(
                  future: _loaddata(),
                  builder: (context, AsyncSnapshot<List<Cart>> snapshot) {
                    print(snapshot.connectionState);
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      return Container(
                          child: ListView.separated(
                              separatorBuilder:
                                  (BuildContext context, int index) =>
                                      const Divider(
                                        thickness: 3,
                                      ),
                              itemCount: snapshot.data.length,
                              //itemExtent: 70.0,
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) {
                                return Row(
                                  children: [
                                    SizedBox(width: 10, height: 20),
                                    Container(
                                        height: 75,
                                        width: 75,
                                        decoration: BoxDecoration(
                                            color: Colors.black12,
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                        child: Image.network(
                                          snapshot.data[index].imageurl,
                                        )),
                                    SizedBox(width: 25),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${snapshot.data[index].desc}',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          '(500 g)\t\t Rs.'
                                          '${snapshot.data[index].price}',
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.normal,
                                              color: Colors.black),
                                        ),
                                        SizedBox(height: 5),
                                        Container(
                                            height: 40,
                                            //width: 100,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.grey,
                                                  width: 1.0),
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                            ),
                                            child: Row(children: [
                                              IconButton(
                                                icon: new Icon(Icons.remove),
                                                onPressed: () {
                                                  setState(() {
                                                    if (snapshot.data[index]
                                                            .quantity >
                                                        1) {
                                                      qty = snapshot
                                                          .data[index].quantity;
                                                      desc = snapshot
                                                          .data[index].desc
                                                          .toString();
                                                      price = snapshot
                                                          .data[index].price;

                                                      minus(desc, qty, price);
                                                    } else {
                                                      id = snapshot
                                                          .data[index].id;
                                                      del(id);
                                                    }
                                                  });
                                                },
                                                color: Colors.green,
                                              ),
                                              Text(
                                                  '${snapshot.data[index].quantity}'),
                                              IconButton(
                                                icon: new Icon(Icons.add),
                                                onPressed: () {
                                                  qty = snapshot
                                                      .data[index].quantity;
                                                  desc =
                                                      snapshot.data[index].desc;
                                                  price = snapshot
                                                      .data[index].price;
                                                  print("quantity");
                                                  print(qty);
                                                  add(desc, qty, price);
                                                },
                                                color: Colors.green,
                                              ),
                                            ]))
                                      ],
                                    ),
                                    SizedBox(width: 75),
                                    Text('Rs  '
                                        '${snapshot.data[index].total}'),
                                  ],
                                );

                                /* return Card(
                                      child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: ListTile(
                                              //   title:Text("welcome"),
                                              title: Text(
                                                  '${snapshot.data[index].desc}'),
                                              subtitle: Row(
                                                children: <Widget>[
                                                  Image.network(
                                                    snapshot
                                                        .data[index].imageurl,
                                                    // 'https://placeimg.com/250/250/any',
                                                    fit: BoxFit.cover,
                                                  ),
                                                  Text('Rs:'),
                                                  Text(
                                                      '${snapshot.data[index].price}'),
                                                ],
                                              ),
                                              trailing: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: <Widget>[
                                                    IconButton(
                                                      icon: new Icon(
                                                          Icons.remove),
                                                      onPressed: () {
                                                        setState(() {
                                                          if (snapshot
                                                                  .data[index]
                                                                  .quantity >
                                                              1) {
                                                            qty = snapshot
                                                                .data[index]
                                                                .quantity;
                                                            desc = snapshot
                                                                .data[index]
                                                                .desc
                                                                .toString();
                                                            price = snapshot
                                                                .data[index]
                                                                .price;

                                                            minus(desc, qty,
                                                                price);
                                                          } else {
                                                            id = snapshot
                                                                .data[index].id;
                                                            del(id);
                                                          }
                                                        });
                                                      },
                                                      color: Colors.green,
                                                    ),
                                                    Text(
                                                        '${snapshot.data[index].quantity}'),
                                                    IconButton(
                                                      icon: new Icon(Icons.add),
                                                      onPressed: () {
                                                        qty = snapshot
                                                            .data[index]
                                                            .quantity;
                                                        desc = snapshot
                                                            .data[index].desc;
                                                        price = snapshot
                                                            .data[index].price;
                                                        print("quantity");
                                                        print(qty);
                                                        add(desc, qty, price);
                                                      },
                                                      color: Colors.green,
                                                    ),
                                                    Text(
                                                        '${snapshot.data[index].total}'),
                                                    IconButton(
                                                      icon: new Icon(
                                                          Icons.delete),
                                                      color: Colors.redAccent,
                                                      onPressed: () {
                                                        id = snapshot
                                                            .data[index].id;
                                                        del(id);
                                                      },
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                    )
                                                  ]))));*/
                              }));
                    }
                  },
                ),
              ),
              Divider(thickness: 15, color: Colors.lightGreen),
              Container(
                  padding: EdgeInsets.only(left: 20),
                  child: Row(children: [
                    SizedBox(
                      height: 50,
                    ),
                    Text(
                      "Bill Details",
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          .copyWith(color: Colors.black),
                    )
                  ])),
              SizedBox(height: 10),
              Container(
                  padding: EdgeInsets.only(left: 50),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          "Item Total",
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1
                              .copyWith(color: Colors.black),
                        ),
                        // SizedBox(width: 75),
                        // Wrap(children: [
                        // Text("\u20B9"),
                        Text(
                          '\u20B9' '$_total',
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1
                              .copyWith(color: Colors.black),
                        )
                        // ])
                      ])),
              SizedBox(height: 10),
              Container(
                  padding: EdgeInsets.only(left: 50),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          "Delivery Fee",
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1
                              .copyWith(color: Colors.black),
                        ),
                        //SizedBox(width: 75),
                        Text(
                          '\u20B9' '25.0',
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1
                              .copyWith(color: Colors.black),
                        ),
                      ])),
              Divider(thickness: 1, color: Colors.grey),
              Container(
                  padding: EdgeInsets.only(left: 50),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          "To Pay",
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              .copyWith(color: Colors.black),
                        ),
                        //SizedBox(width: 75),
                        _gtotal != 0
                            ? Text(
                                '\u20B9' '$_gtotal',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    .copyWith(color: Colors.black),
                              )
                            : Container(),
                      ])),
              SizedBox(
                height: 35,
              ),
              ElevatedButton(
                child: new Text("Place Order"),
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                  onPrimary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32.0),
                  ),
                ),
                onPressed: () async {
                  checkRegister();

                  // Navigator.push(context,
                  //    MaterialPageRoute(builder: (context) => SecondPage()));
                },
              )
            ])));
  }
}

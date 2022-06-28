import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:order_app/page/viewcart.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:order_app/model/cart.dart';

import 'package:order_app/model/order.dart';

import 'package:order_app/DBHelp.dart';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:order_app/page/order_accepted_screen.dart';

class Checkout extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => check_out();
}

class check_out extends State<Checkout> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  String address;
  String phone;
  String name;
  String email;

  int _total;

  int _gtotal;
  final dbHelper = DBHelp.instance;
  List<Cart> cart = [];
  List<Order> order = [];
  void initState() {
    loadaddress();
    loaddata();
    _calcTotal();
  }

  void loadaddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      address = prefs.getString('address');
      phone = prefs.getString('phone');
      name = prefs.getString('name');
      print(name);
      // addressController.text = address;
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

  finalorder() async {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    final String formatted = formatter.format(now);

    final Rows = await dbHelper.queryDetails();
    Rows.forEach((row) => print(row));
    Rows.forEach((row) => cart.add(Cart.fromMap(row)));
    print("cart Details");
    print(cart);
    Map<String, dynamic> row = {
      DBHelp.columnDate: formatted,
      DBHelp.columnAddress: address,
      DBHelp.columnPhone: phone,
      DBHelp.columnName: name,
    };

    Order order = Order.fromMap(row);
    dbHelper.deletecontacttable();
    final id = await dbHelper.inserthistory(order);
    print('address details row inserted');

    final allRows = await dbHelper.queryAllRowshistory();

    print('query all rows:');
    allRows.forEach((row) => print(row));
    pushorder();
  }

  Future<String> pushorder() async {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    final String formatted = formatter.format(now);

    print("loaddata calling");

    final Rows = await dbHelper.queryDetails();
    final Rows1 = await dbHelper.queryAllRowshistory();
    //  Map<String, dynamic> data = {"jsonCart": Rows, "jsonContact": Rows1};
    String jsonCart = jsonEncode(Rows);
    String jsonContact = jsonEncode(Rows1);
    List<Map<String, dynamic>> newList = Rows + Rows1;
    print("new List");
    print(newList);
    // var body = Order.fromMap(formatted,)
    //  String jsonFinal = jsonEncode(body);
    // print("combined details");
    // final queryParameters = {
    //   "cart": jsonCart,
    //   "contact": jsonContact,
    // };

    // String b = jsonEncode(newList);
    // print(b);

    //set up POST request arguments

    String url = 'http://glenshop.000webhostapp.com/hosp/Api/order';
    // String url1 = 'http://glenshop.000webhostapp.com/hosp/Api/contact';

    Map<String, String> headers = {"Content-type": "application/json"};
    try {
      http.Response response =
          await http.post(url, headers: headers, body: jsonEncode(newList));
      // http.Response response1 =
      //  await http.post(url1, headers: headers, body: jsonUser1);

      print(response.statusCode);
      //  print(response1.statusCode);

      print(response.body.toString());

      var data = jsonDecode(response.body);
      // var data1 = jsonDecode(response1.body);

      String status = data["status"];
      // String status1 = data["status"];

      if (status == "success"

          // && status1 == "success"
          ) {
        print(response.body.toString());
        //  print(response1.body.toString());
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => OrderAcceptedScreen()));

        //    return status;
      }
    } catch (err) {
      print('Caught error: $err');

      /// return err;
    }
    // Navigator.push(context,
    //  MaterialPageRoute(builder: (context) => OrderAcceptedScreen()));
  }

  Future<List<Cart>> loaddata() async {
    print("loaddata calling");

    final Rows = await dbHelper.queryDetails();
    print('query loaddata item details :');
    Rows.forEach((row) => print(row));
    cart.clear();
    //  print(Rows);
    Rows.forEach((row) => cart.add(Cart.fromMap(row)));
    print(cart.length);
    setState(() {
      cart = cart;
    });
    // if (cart.length == 0) {
    //  Navigator.push(
    //    context, MaterialPageRoute(builder: (context) => EmptyCart()));
    // } else {
    return cart;
    // }
  }

  _verticalDivider() => Container(
        padding: EdgeInsets.all(2.0),
      );

  _verticalD() => Container(
        margin: EdgeInsets.only(left: 15.0, right: 0.0, top: 0.0, bottom: 0.0),
      );
  _verticalBig() => Container(
        margin: EdgeInsets.only(left: 35.0, right: 0.0, top: 0.0, bottom: 0.0),
      );
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            centerTitle: true,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ViewCart()))
                    .then((_) {
                  setState(() {});
                });
              },
            ),

            //iconTheme: IconThemeData(color: Colors.black),
            title: Column(
              // crossAxisAlignment: CrossAxisAlignment.s.start,
              children: [
                Text("CheckOut",
                    style: Theme.of(context)
                        .textTheme
                        .headline5
                        .copyWith(color: Colors.blueGrey)),
              ],
            )),
        body: Column(children: <Widget>[
          Container(
              margin: EdgeInsets.all(5.0),
              child: Card(
                  child: Container(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          // three line description
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Container(
                                    alignment: Alignment.center,
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          'Delivery',
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                        IconButton(
                                            icon: Icon(
                                              Icons.play_circle_outline,
                                              color: Colors.blue,
                                            ),
                                            onPressed: null)
                                      ],
                                    )),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Container(
                                    alignment: Alignment.center,
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          'Cash on Delivery',
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black38),
                                        ),
                                        IconButton(
                                            icon: Icon(
                                              Icons.check_circle,
                                              color: Colors.black38,
                                            ),
                                            onPressed: null)
                                      ],
                                    )),
                              ),
                            ],
                          ),
                        ],
                      )))),
          Container(
            alignment: Alignment.topLeft,
            margin:
                EdgeInsets.only(left: 12.0, top: 5.0, right: 0.0, bottom: 5.0),
            child: Text(
              'Delivery Address',
              style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0),
            ),
          ),
          Container(
            height: 175.0,
            width: 250.0,
            margin: EdgeInsets.all(7.0),
            child: Card(
              elevation: 3.0,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(
                            left: 12.0, top: 5.0, right: 0.0, bottom: 5.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              '$address',
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          _verticalDivider(),
          Container(
            alignment: Alignment.topLeft,
            margin:
                EdgeInsets.only(left: 12.0, top: 5.0, right: 0.0, bottom: 5.0),
            child: Text(
              'Order Summary',
              style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0),
            ),
          ),
          Container(
              margin: EdgeInsets.only(
                  left: 12.0, top: 5.0, right: 12.0, bottom: 5.0),
              height: 250.0,
              child: ListView.builder(
                  itemCount: cart.length,
                  //  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext cont, int ind) {
                    return SafeArea(
                        child: Column(
                      children: <Widget>[
                        Divider(height: 15.0),
                        Container(
                          padding: EdgeInsets.all(5.0),
                          child: Row(
                            //mainAxisSize: MainAxisSize.max,
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(cart[ind].desc,
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold)),
                              _verticalD(),
                              Text(cart[ind].unit,
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.black45,
                                      fontWeight: FontWeight.bold)),
                              Icon(Icons.close, size: 15.0),
                              Text(cart[ind].quantity.toString(),
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.black45,
                                      fontWeight: FontWeight.bold)),
                              _verticalBig(),
                              Text('\u{20B9}'),
                              Text(cart[ind].total.toString(),
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ],
                    ));
                  })),
          Divider(),
          Container(
              alignment: Alignment.bottomLeft,
              height: 50.0,
              child: Card(
                  child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                    IconButton(icon: Icon(Icons.info), onPressed: null),
                    Text(
                      'Total :',
                      style: TextStyle(
                          fontSize: 17.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '\u20B9' '$_gtotal',
                      style: TextStyle(fontSize: 17.0, color: Colors.black54),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          alignment: Alignment.center,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              ),
                              side: BorderSide(color: Colors.amber.shade500),
                            ),
                            onPressed: () {
                              finalorder();
                            },
                            child: Text(
                              'CONFIRM ORDER',
                              style:
                                  TextStyle(color: Colors.blue, fontSize: 15),
                            ),
                          )),
                    ),
                  ]))),
        ]));
  }
}

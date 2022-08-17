import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'dart:io';
import 'package:order_app/DBHelp.dart';
import 'package:order_app/main.dart';
import 'package:order_app/page/profile_page.dart';
import 'package:order_app/page/bill_details.dart';

import 'package:order_app/model/cart.dart';

import 'package:order_app/model/history.dart';

import 'package:order_app/services/Services.dart';
import 'package:intl/intl.dart';
//import 'package:grocery_app/common_widgets/app_button.dart';

class OrderHistory extends StatefulWidget {
  @override
  OrderHistoryState createState() => OrderHistoryState();
}

class OrderHistoryState extends State<OrderHistory> {
  final dbHelper = DBHelp.instance;
  List<History> history = [];
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    setState(() {
      _loaddata();
    });
  }

  Future<List<History>> _loaddata() async {
    print("loaddata calling");
    Services.fetchHistory().then((bannersFromServer) {
      setState(() {
        history = bannersFromServer;
        print(history.length);
        //isLoading = false;
      });
    });
    //final Rows = await dbHelper.historyqueryDetails();
    print('query history details :');
    //var now = DateTime.now();
    //var formatterDate = DateFormat('dd/MM/yy');
    // var formatterTime = DateFormat('kk:mm');
    // String actualDate = formatterDate.format(now);
    // String actualTime = DateFormat.jm().format(now);
    // Rows.forEach((row) => print(row));
    history.clear();
    // print(actualTime);

    // Rows.forEach((row) => cart.add(Cart.fromMap(row)));
    // print(cart.length);
    setState(() {
      history = history;
    });
    // if (cart.length == 0) {
    //  Navigator.push(
    //    context, MaterialPageRoute(builder: (context) => EmptyCart()));
    // } else {

    return history;
    // }
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
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ProfilePage()))
                    .then((_) {
                  // setState(() {});
                });
              },
            ),

            //iconTheme: IconThemeData(color: Colors.black),
            title: Column(
              // crossAxisAlignment: CrossAxisAlignment.s.start,
              children: [
                Text("Order History",
                    style: Theme.of(context)
                        .textTheme
                        .headline5
                        .copyWith(color: Colors.blueGrey)),
              ],
            )),
        body: ListView.builder(
            itemCount: history.length,
            itemBuilder: (BuildContext cont, int ind) {
              return SafeArea(
                  child: Column(children: <Widget>[
                Container(
                    margin: EdgeInsets.only(left: 5.0, right: 5.0, bottom: 5.0),
                    color: Colors.black12,
                    child: Card(
                        elevation: 4.0,
                        child: Container(
                            padding: const EdgeInsets.fromLTRB(
                                10.0, 10.0, 10.0, 10.0),
                            child: GestureDetector(
                                child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                // three line description
                                /*Container(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    history[ind].id.toString(),
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontStyle: FontStyle.normal,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),*/

                                Container(
                                  margin: EdgeInsets.only(top: 3.0),
                                ),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Expanded(
                                          flex: 5,
                                          child: Container(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              'Order Id :' + history[ind].id,
                                              style: TextStyle(
                                                  fontSize: 13.0,
                                                  color: Colors.black87),
                                            ),
                                          )),
                                      Expanded(
                                          flex: 2,
                                          child: Container(
                                              alignment: Alignment.topLeft,
                                              child: Row(children: <Widget>[
                                                Text(
                                                  'Bill Details :',
                                                  style: TextStyle(
                                                      fontSize: 15.0,
                                                      color: Colors.black87),
                                                ),
                                                InkWell(
                                                  child: Icon(
                                                    Icons.arrow_forward_ios,
                                                    size: 20.0,
                                                  ),
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                BillDetails(
                                                                    id: history[
                                                                            ind]
                                                                        .id)));
                                                  },
                                                ),
                                              ]))),
                                    ]),
                                Divider(
                                  height: 10.0,
                                  color: Colors.amber.shade500,
                                ),

                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                        padding: EdgeInsets.all(3.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              'Date',
                                              style: TextStyle(
                                                  fontSize: 13.0,
                                                  color: Colors.black54),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(top: 3.0),
                                              child: Text(
                                                history[ind].date,
                                                style: TextStyle(
                                                    fontSize: 15.0,
                                                    color: Colors.black87),
                                              ),
                                            )
                                          ],
                                        )),
                                    Container(
                                        padding: EdgeInsets.all(3.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              'Order Amount',
                                              style: TextStyle(
                                                  fontSize: 13.0,
                                                  color: Colors.black54),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(top: 3.0),
                                              child: Text(
                                                history[ind].gtotal,
                                                style: TextStyle(
                                                    fontSize: 15.0,
                                                    color: Colors.black87),
                                              ),
                                            ),
                                          ],
                                        )),
                                    Container(
                                        padding: EdgeInsets.all(3.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              'Status',
                                              style: TextStyle(
                                                  fontSize: 13.0,
                                                  color: Colors.black54),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(top: 3.0),
                                              child: Text(
                                                history[ind].status,
                                                style: TextStyle(
                                                    fontSize: 15.0,
                                                    color: Colors.black87),
                                              ),
                                            )
                                          ],
                                        )),
                                  ],
                                ),
                                Divider(
                                  height: 10.0,
                                  color: Colors.amber.shade500,
                                ),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Icon(
                                      Icons.location_on,
                                      size: 20.0,
                                      color: Colors.amber.shade500,
                                    ),
                                    Text(history[ind].time,
                                        style: TextStyle(
                                            fontSize: 13.0,
                                            color: Colors.black54)),
                                  ],
                                ),
                                Divider(
                                  height: 10.0,
                                  color: Colors.amber.shade500,
                                ),
                              ],
                            ))))),
              ]));
            }));
  }
}

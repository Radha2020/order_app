import 'package:flutter/material.dart';

import 'package:order_app/page/order_history.dart';

void main() {
  var id;
  runApp(MaterialApp(
    home: BillDetails(id: id),
  ));
}

class BillDetails extends StatefulWidget {
  final String id;
  BillDetails({Key key, @required this.id}) : super(key: key);
  @override
  BillDetailsState createState() => BillDetailsState();
}

class BillDetailsState extends State<BillDetails> {
  @override
  String id;
  void initState() {
    print(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        // key: _scaffoldKey,
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
                        MaterialPageRoute(builder: (context) => OrderHistory()))
                    .then((_) {
                  setState(() {});
                });
              },
            ),

            //iconTheme: IconThemeData(color: Colors.black),
            title: Column(
              // crossAxisAlignment: CrossAxisAlignment.s.start,
              children: [
                Text("Bill Details",
                    style: Theme.of(context)
                        .textTheme
                        .headline5
                        .copyWith(color: Colors.blueGrey)),
              ],
            )),
        body: Column(children: <Widget>[
          Container(
            alignment: Alignment.topLeft,
            margin:
                EdgeInsets.only(left: 12.0, top: 5.0, right: 0.0, bottom: 5.0),
            /*child: Text(
              'Order Summary',
              style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0),
            ),*/
          ),
        ]));
  }
}

import 'package:flutter/material.dart';
import 'package:order_app/model/items.dart';
import 'package:order_app/services/Services.dart';
import 'package:badges/badges.dart';
import 'package:order_app/model/cart.dart';
import 'package:order_app/main.dart';
import 'package:order_app/page/viewcart.dart';

import 'package:order_app/DBprovider.dart';

void main() {
  var title;
  runApp(MaterialApp(
    home: Product_detailsPage(title: title),
  ));
}

class Product_detailsPage extends StatefulWidget {
  final String title;
  Product_detailsPage({Key key, @required this.title}) : super(key: key);

  @override
  Product_detailsPageState createState() => Product_detailsPageState();
}

class Product_detailsPageState extends State<Product_detailsPage> {
  final dbHelper = DBprovider.instance;
  String title;
  List<Items> items = List();
  List<Items> filtereditems = List();
  int quan;
  int _n = 1;
  int _id;
  String totPrice = "";
  int _total;
  int _counter;
  int rowid;
  int id = -1;
  String selectedPrice = "";
  String selectedItem = "";
  String selectedCode = '';
  String selectedimageurl = '';
  TextEditingController codecontroller = TextEditingController();

  @override
  void initState() {
    print(widget.title);
    dbHelper.deletetable();
    // dbHelper.database;
    Services.fetchData().then((itemsFromServer) {
      setState(() {
        // print(filtereditems.length);
        items = itemsFromServer;
        filtereditems = items;
        _counter = 0;
      });
    });
    setState(() {
      title = widget.title;
    });
    // print(this.title);
  }

  void add(desc, _n, price, image) async {
    var tot = _n * int.parse(price);
    print("total");
    print(tot);
    Map<String, dynamic> row = {
      DBprovider.columnImage: image,
      DBprovider.columnDesc: desc,
      DBprovider.columnQuantity: _n,
      DBprovider.columnTotal: tot,
    };
    dbHelper.update(row, desc);
    _calcTotal();

    final allRows = await dbHelper.queryAllRows();
    print('query all rows:');
    allRows.forEach((row) => print(row));
  }

  void minus(desc, _n, price) async {
    print("minus part");
    print(desc);
    var tot = _n * int.parse(price);
    Map<String, dynamic> row = {
      DBprovider.columnDesc: desc,
      DBprovider.columnQuantity: _n,
      DBprovider.columnTotal: tot,
    };
    dbHelper.update(row, desc);
    _calcTotal();
    final allRows = await dbHelper.queryAllRows();
    print('query all rows:');
    allRows.forEach((row) => print(row));
  }

  void del(desc) async {
    print("desc");
    print(desc);
    // dbHelper.del(code);
    dbHelper.deleterow(desc);
    var count =
        await dbHelper.queryRowCount().then((value) => _counter = value);
    setState(() {
      _counter = _counter;
    });
    _calcTotal();
    final allRows = await dbHelper.queryAllRows();
    print('query all rows:');
    allRows.forEach((row) => print(row));
  }

  submitData() async {
    //final id = await dbHelper.getlastrowid().then((value) => rowid = value);
    setState(() {
      // rowid = tableid;
      print("code");
      print(selectedCode);
      print("item");
      print(selectedItem);
      print("quantity");
      print(_n);
      print(selectedimageurl);
    });
    // print(id);
    int price = int.parse(selectedPrice);
    int total = _n * price;
    print("price");
    print(price);

    print("total");
    print(total);
    Map<String, dynamic> row = {
      DBprovider.columnCode: selectedCode,
      DBprovider.columnImage: selectedimageurl,
      DBprovider.columnDesc: selectedItem,
      DBprovider.columnPrice: price,
      DBprovider.columnQuantity: _n,
      DBprovider.columnTotal: total
    };
    // int c = await dbHelper.getcount(selectedCode, rowid);

    //var r= dbHelper.getcount(selectedCode).then((value) => c=value);
    //  print("count");
    // print(c);
    //int count=r;
    // if (c == 0) {
    Cart cart = Cart.fromMap(row);
    print(cart.code);
    final id = await dbHelper.insert(cart);
    print('new row inserted');
    //final id = await dbHelper.insert(row);
    print('inserted row id: $id');
    // } else {
    // print(row);
    //  print("already existed");
    // dbHelper.update(row, tableid);
    // }

    var count =
        await dbHelper.queryRowCount().then((value) => _counter = value);
    _calcTotal();
    setState(() {
      _counter = _counter;
    });
    print(_counter);
    //dbHelper.delete();
    final allRows = await dbHelper.queryAllRows();
    print('query all rows:');
    allRows.forEach((row) => print(row));
  }

  void _calcTotal() async {
    print("calculate total");
    var total = await dbHelper.calculateTotal().then((value) => _total = value);
    print(total);
    setState(() => _total = _total);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            centerTitle: true,
            title: Column(
              // crossAxisAlignment: CrossAxisAlignment.s.start,
              children: [
                Text('$title',
                    style: Theme.of(context)
                        .textTheme
                        .headline5
                        .copyWith(color: Colors.redAccent)),
              ],
            )),
        bottomNavigationBar: new BottomNavigationBar(
            // currentIndex: 0, // this will be set when a new tab is tapped
            backgroundColor: Colors.white,
            selectedFontSize: 1.0,
            unselectedFontSize: 1.0,
            items: [
              BottomNavigationBarItem(
                icon: new Stack(children: <Widget>[
                  IconButton(
                    icon: new Icon(Icons.home),
                    color: Colors.brown,
                    onPressed: () {
                      setState(() {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => MyApp()));
                      });
                    },
                    //loadData();
                  ),
                ]),
                title: Text(''),
              ),
              BottomNavigationBarItem(
                title: Text(''),
                icon: _total != null
                    ? Badge(
                        shape: BadgeShape.square,
                        borderRadius: BorderRadius.circular(5),
                        badgeColor: Colors.red,
                        position: BadgePosition.topEnd(top: -12, end: -20),
                        padding: EdgeInsets.all(2),
                        badgeContent: Text(
                          'Rs.' '$_total',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold),
                        ),
                        child: Text(
                          'Total',
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      )
                    : Text(
                        'Total',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
              ),
              BottomNavigationBarItem(
                icon: new Stack(
                  children: <Widget>[
                    IconButton(
                      icon: new Icon(Icons.shopping_cart),
                      color: Colors.brown,
                      onPressed: () {
//                        loadData(selectedtableno);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ViewCart()));

                        setState(() {
                          //  selectedWidgetMarker=WidgetMarker.third;
                        });
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
                title: Text(''),
              ),
            ]),
        body: Padding(
            padding: EdgeInsets.all(8.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(
                  child: TextFormField(
                    onChanged: (string) {
                      setState(() {
                        filtereditems = items
                            .where((i) =>
                                i.code
                                    .toLowerCase()
                                    .contains(string.toLowerCase()) ||
                                i.desc
                                    .toLowerCase()
                                    .contains(string.toLowerCase()))
                            .toList();
                      });
                    },
                    //  controller: editingController,
                    controller: codecontroller,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(15.0),
                      hintText: 'name',
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                )
              ]),
              new Expanded(
                child: ListView.builder(
                    padding: EdgeInsets.all(10.0),
                    itemCount: filtereditems.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                          child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: new ListTile(
                            title: Text('${filtereditems[index].desc}'),
                            subtitle: Row(
                              children: <Widget>[
                                Text('Rs:'),
                                Text('${filtereditems[index].price}'),
                              ],
                            ),
                            leading: Image.network(
                              filtereditems[index].imageUrl,
                              // 'https://placeimg.com/250/250/any',
                              fit: BoxFit.cover,
                            ),
                            // Text('${filtereditems[index].code}'),
                            // ),
                            trailing:
                                // code=snapshot.data[index].code
                                filtereditems[index].ShouldVisible
                                    ? Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                            RaisedButton(
                                              color: Colors.green,
                                              onPressed: () async {
                                                print("code value");
                                                print(items[index].code);
                                                // print("tableid");
                                                print("quan");
                                                print(quan);

                                                if (quan == null) {
                                                  print("if part");
                                                  _n = 1;
                                                  totPrice =
                                                      filtereditems[index]
                                                          .price;
                                                  filtereditems[index].isAdded =
                                                      false;
                                                } else {
                                                  final snackBar = SnackBar(
                                                    backgroundColor:
                                                        Colors.green,
                                                    content: Text(
                                                      'Already Added in the Cart!!',
                                                    ),
                                                    duration:
                                                        Duration(seconds: 2),
                                                  );
                                                  Scaffold.of(context)
                                                      .showSnackBar(snackBar);
                                                  //               _showScaffold("This is a SnackBar.");
                                                  print("else part");
                                                  _n = quan;
                                                }
                                                setState(() {
                                                  filtereditems[index]
                                                      .ShouldVisible = false;
                                                  selectedItem =
                                                      filtereditems[index].desc;
                                                  selectedPrice =
                                                      filtereditems[index]
                                                          .price;
                                                  selectedCode =
                                                      filtereditems[index].code;
                                                  filtereditems[index].counter =
                                                      _n;
                                                  selectedimageurl =
                                                      filtereditems[index]
                                                          .imageUrl;
                                                });

                                                submitData();
                                              },
                                              child: new Text('ADD',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              textColor: Colors.white,
                                            )
                                          ])
                                    //
                                    : Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                            IconButton(
                                              icon: new Icon(Icons.remove),
                                              onPressed: () {
                                                // print("id");
                                                // print(tableid);

                                                setState(() {
                                                  if (filtereditems[index]
                                                          .counter >
                                                      1) {
                                                    print("counter");
                                                    print(filtereditems[index]
                                                        .counter);

                                                    filtereditems[index]
                                                        .counter--;
                                                    _n = filtereditems[index]
                                                        .counter;
                                                    minus(
                                                      filtereditems[index].desc,
                                                      _n,
                                                      filtereditems[index]
                                                          .price,
                                                    );
                                                  } else {
                                                    print(" less counter");
                                                    print(filtereditems[index]
                                                        .counter);
                                                    setState(() {
                                                      filtereditems[index]
                                                          .ShouldVisible = true;
                                                      filtereditems[index]
                                                          .isAdded = true;
                                                    });
                                                    del(filtereditems[index]
                                                        .desc);
                                                  }
                                                });
                                              },
                                              color: Colors.green,
                                            ),
                                            Text(filtereditems[index]
                                                .counter
                                                .toString()),
                                            IconButton(
                                              icon: new Icon(Icons.add),
                                              onPressed: () {
                                                setState(() {
                                                  _id = index;
                                                  filtereditems[index]
                                                      .counter++;
                                                  _n = filtereditems[index]
                                                      .counter;
                                                  print("quan");
                                                  print(_n);
                                                  add(
                                                      filtereditems[index].desc,
                                                      _n,
                                                      filtereditems[index]
                                                          .price,
                                                      filtereditems[index]
                                                          .imageUrl);
                                                });
                                              },
                                              color: Colors.green,
                                            )
                                          ])),
                      ));
                    }),
              ),
            ])));
  }
}

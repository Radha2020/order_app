import 'package:order_app/DBHelp.dart';

import 'package:order_app/model/cart.dart';

class Order {
  String date;
  String time;
  String name;
  String address;
  String phone;
  int gtotal;
//  List<Cart> cart;
  Order(
      {this.date, this.time, this.name, this.address, this.phone, this.gtotal});

  factory Order.fromMap(Map<String, dynamic> map) {
    // List<Cart> cartlist = list.map((i) => Cart.fromMap(i)).toList();
    // new List<Cart>.from(map["Cart"].map((x) => Cart.fromMap(x)));
    print("cart list");
    //  print(cartlist);
    return Order(
        date: map['date'],
        time: map['time'],
        name: map['name'],
        address: map['address'],
        phone: map['phone'],
        gtotal: map['gtotal']);
  }
  Map<String, dynamic> toJson() {
    return {
      DBHelp.columnDate: date,
      DBHelp.columnTime: time,
      DBHelp.columnName: name,
      DBHelp.columnAddress: address,
      DBHelp.columnPhone: phone,
      DBHelp.columnGtotal: gtotal,
      // DBHelp.columnList: cart,
    };
  }
}

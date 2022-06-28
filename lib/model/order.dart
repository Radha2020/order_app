import 'package:order_app/DBHelp.dart';

import 'package:order_app/model/cart.dart';

class Order {
  String date;
  String name;
  String address;
  String phone;
//  List<Cart> cart;
  Order({this.date, this.name, this.address, this.phone});

  factory Order.fromMap(Map<String, dynamic> map) {
    // List<Cart> cartlist = list.map((i) => Cart.fromMap(i)).toList();
    // new List<Cart>.from(map["Cart"].map((x) => Cart.fromMap(x)));
    print("cart list");
    //  print(cartlist);
    return Order(
        date: map['date'],
        name: map['name'],
        address: map['address'],
        phone: map['phone']
        //    cart: cartlist
        );
  }
  Map<String, dynamic> toJson() {
    return {
      DBHelp.columnDate: date,
      DBHelp.columnName: name,
      DBHelp.columnAddress: address,
      DBHelp.columnPhone: phone,
      DBHelp.columnPhone: phone,
      // DBHelp.columnList: cart,
    };
  }
}

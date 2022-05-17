import 'package:order_app/DBHelp.dart';

import 'package:order_app/model/cart.dart';

class Order {
  String date;
  String name;
  String address;
  String phone;

  Order({this.date, this.name, this.address, this.phone});

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      date: map['date'],
      name: map['name'],
      address: map['address'],
      phone: map['phone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      DBHelp.columnDate: date,
      DBHelp.columnName: name,
      DBHelp.columnAddress: address,
      DBHelp.columnPhone: phone,
    };
  }
}

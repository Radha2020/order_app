import 'package:order_app/DBHelp.dart';

class Cart {
  int id;
  String code;
  String imageurl;
  String desc;
  String unit;
  int price;
  int quantity;
  int total;

  Cart(this.id, this.code, this.imageurl, this.desc, this.unit, this.price,
      this.quantity, this.total);

  Cart.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    code = map['code'];
    imageurl = map['imageurl'];
    desc = map['desc'];
    unit = map['unit'];
    price = map['price'];
    quantity = map['quantity'];
    total = map['total'];
  }

  Map<String, dynamic> toMap() {
    return {
      DBHelp.columnId: id,
      DBHelp.columnCode: code,
      DBHelp.columnImage: imageurl,
      DBHelp.columnDesc: desc,
      DBHelp.columnUnit: unit,
      DBHelp.columnPrice: price,
      DBHelp.columnQuantity: quantity,
      DBHelp.columnTotal: total
      //   DatabaseHelper.columnMiles: miles,
    };
  }
}

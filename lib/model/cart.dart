import 'package:order_app/services/DBprovider.dart';

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
      DBprovider.columnId: id,
      DBprovider.columnCode: code,
      DBprovider.columnImage: imageurl,
      DBprovider.columnDesc: desc,
      DBprovider.columnUnit: unit,
      DBprovider.columnPrice: price,
      DBprovider.columnQuantity: quantity,
      DBprovider.columnTotal: total
      //   DatabaseHelper.columnMiles: miles,
    };
  }
}

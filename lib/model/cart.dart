import 'package:order_app/DBprovider.dart';

class Cart {
  int id;
  String code;
  String imageurl;
  String desc;
  int price;
  int quantity;
  int total;

  Cart(this.id, this.code, this.imageurl, this.desc, this.price, this.quantity,
      this.total);

  Cart.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    code = map['code'];
    imageurl = map['imageurl'];
    desc = map['desc'];
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
      DBprovider.columnPrice: price,
      DBprovider.columnQuantity: quantity,
      DBprovider.columnTotal: total
      //   DatabaseHelper.columnMiles: miles,
    };
  }
}

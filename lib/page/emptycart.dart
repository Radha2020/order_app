import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:order_app/main.dart';

class EmptyCart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 100),
          width: 200,
          height: 200,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/emptycart.png'), fit: BoxFit.fill)),
        ),
        Text(
          "Your Cart Is Empty",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyText2.copyWith(
              fontWeight: FontWeight.bold, fontSize: 36, color: Colors.amber),
        ),
        SizedBox(height: 30),
        Text(
          "Looks Like you didn't \n add anything to your cart yet",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.subtitle2.copyWith(
              fontWeight: FontWeight.bold, fontSize: 26, color: Colors.grey),
        ),
        SizedBox(height: 30),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.green,
            onPrimary: Colors.white,
            shadowColor: Colors.greenAccent,
            elevation: 3,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32.0)),
            minimumSize: Size(200, 40), //////// HERE
          ),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => MyApp()));
          },
          child: Text('Shop Now'),
        )
      ],
    ));
  }
}

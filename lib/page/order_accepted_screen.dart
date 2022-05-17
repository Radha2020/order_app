import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:order_app/DBHelp.dart';
import 'package:order_app/main.dart';
//import 'package:grocery_app/common_widgets/app_button.dart';

class OrderAcceptedScreen extends StatelessWidget {
  final dbHelper = DBHelp.instance;

  void delete() {
    dbHelper.deletetable();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.maxFinite,
        padding: EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Spacer(
              flex: 10,
            ),
            SvgPicture.asset("assets/icons/order_accepted_icon.svg"),
            Spacer(
              flex: 8,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                "You Order Has Been Accepted",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                "Your item has been placed and is on it's way to being processed",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 16,
                    color: Color(0xff7C7C7C),
                    fontWeight: FontWeight.w600),
              ),
            ),
            Spacer(
              flex: 8,
            ),
            /*ElevatedButton(
              child: new Text("Place Order"),
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
                onPrimary: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32.0),
                ),
              ),
              onPressed: () async {
                // checkRegister();

                // Navigator.push(context,
                //    MaterialPageRoute(builder: (context) => SecondPage()));
              },
            ),*/
            Spacer(
              flex: 2,
            ),
            InkWell(
              onTap: () {
                delete();
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => MyApp()));
              },
              child: Text(
                "Back To Home",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Spacer(
              flex: 10,
            ),
          ],
        ),
      ),
    );
  }
}

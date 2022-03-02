import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:shared_preferences/shared_preferences.dart';

// This class handles the Page to dispaly the user's info on the "Edit Profile" Screen
class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  final image = AssetImage('assets/user.png');
  String name;
  String email;
  void initState() {
    loaddata();
  }

  void loaddata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name');
      email = prefs.getString('email');
      print(name);
      print(email);
    });
  }

  Widget build(BuildContext context) {
//    final user = UserData.myUser;

    return Scaffold(
        body: Column(children: [
      AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 10,
      ),
      Center(
          child: Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text(
                'Profile',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  //  color: Color.fromRGBO(64, 105, 225, 1),
                ),
              ))),
      Column(
        children: [
          SizedBox(
              height: 115,
              width: 115,
              child: CircleAvatar(
                backgroundColor: Color.fromRGBO(220, 220, 220, 1),
                backgroundImage: AssetImage('assets/user.png'),
              )),
          Row(children: [
            Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  '$name   $email',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    //  color: Color.fromRGBO(64, 105, 225, 1),
                  ),
                )),
          ]),
          SizedBox(height: 20),
          ProfileMenu(
            icon: "assets/User Icon.svg",
            text: "My Account",
            press: () {},
          ),
          ProfileMenu(
            icon: "assets/User Icon.svg",
            text: "Past Order",
            press: () {},
          ),
          ProfileMenu(
            icon: "assets/User Icon.svg",
            text: "Log Out",
            press: () {},
          ),
        ],
      )
    ]));
  }
}

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({
    @required this.icon,
    @required this.text,
    @required this.press,
    Key key,
  }) : super(key: key);
  final String text, icon;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextButton(
        style: TextButton.styleFrom(
          primary: Colors.black45,
          padding: EdgeInsets.all(20),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: Color(0xFFF5F6F9),
        ),
        onPressed: press,
        child: Row(
          children: [
            SvgPicture.asset(
              icon,
              color: Color(0xFFFF7643),
              width: 22,
            ),
            SizedBox(width: 20),
            Expanded(child: Text(text)),
            Icon(Icons.arrow_forward_ios),
          ],
        ),
      ),
    );
  }
}

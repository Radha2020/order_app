import 'dart:async';

import 'package:order_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:order_app/page/account_details.dart';

import 'package:order_app/auth/registration.dart';

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
  final _scaffoldKey = GlobalKey<ScaffoldState>();

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

  callpage() async {
    print("account pressed");
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getString('name') == null) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => SecondPage()));
    } else {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => Account_detailsPage()));
    }
  }

  void clearuser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp()));
  }

  Widget build(BuildContext context) {
//    final user = UserData.myUser;
    return WillPopScope(
        onWillPop: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MyApp()));
        },
        child: Scaffold(
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
              email != null
                  ? Row(children: [
                      Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text(
                          '$email',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            color: Color.fromRGBO(64, 105, 225, 1),
                          ),
                        ),
                      ),
                    ])
                  : Row(),
              SizedBox(height: 20),
              ProfileMenu(
                icon: "assets/User Icon.svg",
                text: "My Account",
                press: () async {
                  callpage();
                  //  Navigator.push(context,
                  //           MaterialPageRoute(builder: (context) => Account_detailsPage()));
                },
              ),
              ProfileMenu(
                icon: "assets/User Icon.svg",
                text: "Past Order",
                press: () {},
              ),
              ProfileMenu(
                icon: "assets/User Icon.svg",
                text: "Log Out",
                press: () {
                  clearuser();
                },
              ),
            ],
          )
        ])));
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

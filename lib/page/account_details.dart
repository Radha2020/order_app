import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:order_app/page/update_address.dart';
import 'package:order_app/page/update_name.dart';
import 'package:order_app/page/update_email.dart';
import 'package:order_app/page/update_phone.dart';
import 'package:order_app/page/profile_page.dart';

class Account_detailsPage extends StatefulWidget {
  @override
  Account_detailsPageState createState() => Account_detailsPageState();
}

class Account_detailsPageState extends State<Account_detailsPage> {
  String name;
  String email;
  String phone;
  String address;

  void initState() {
    loaddata();
  }

  void loaddata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name');
      email = prefs.getString('email');
      phone = prefs.getString('phone');
      address = prefs.getString('address');

      print(name);
      print(email);
      print(phone);
      print(address);
    });
  }

  void updateaddress() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Update_addressPage()));
  }

  void updatename() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Update_namePage()));
  }

  void updateemail() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Update_emailPage()));
  }

  void updatephone() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Update_phonePage()));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              toolbarHeight: 20,
            ),
            body: Column(children: [
              Row(children: [
                Padding(
                  padding: EdgeInsets.only(),
                  child: IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfilePage()));
                      },
                      icon: Icon(Icons.arrow_back)),
                ),
                Padding(
                    padding: EdgeInsets.fromLTRB(20, 20, 10, 10),
                    child: Text("Account Details",
                        style: Theme.of(context)
                            .textTheme
                            .headline5
                            .copyWith(color: Colors.redAccent))),
              ]),
              Menu(
                text: "Name:",
                text1: '$name',
                press: () {
                  updatename();
                  //  Navigator.push(context,
                  //           MaterialPageRoute(builder: (context) => Account_detailsPage()));
                },
              ),
              Divider(
                thickness: 1.0,
                color: Colors.grey,
              ),
              Menu(
                text: "Email:",
                text1: '$email',
                press: () {
                  updateemail();
                  //  Navigator.push(context,
                  //           MaterialPageRoute(builder: (context) => Account_detailsPage()));
                },
              ),
              Divider(
                thickness: 1.0,
                color: Colors.grey,
              ),
              Menu(
                text: "Phone:",
                text1: '$phone',
                press: () {
                  updatephone();
                  //  Navigator.push(context,
                  //           MaterialPageRoute(builder: (context) => Account_detailsPage()));
                },
              ),
              Divider(
                thickness: 1.0,
                color: Colors.grey,
              ),
              Menu(
                text: "Address:",
                text1: '$address',
                press: () {
                  updateaddress();
                  //  Navigator.push(context,
                  //           MaterialPageRoute(builder: (context) => Account_detailsPage()));
                },
              ),
            ])));
  }
}

class Menu extends StatelessWidget {
  const Menu({
    @required this.text,
    @required this.text1,
    @required this.press,
    Key key,
  }) : super(key: key);
  final String text, text1;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              text,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                color: Colors.black45,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
                child: Text(text1,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: Colors.black45,
                    ))),

            IconButton(
              icon: Icon(
                Icons.arrow_forward_ios,
              ),
              iconSize: 25,
              color: Colors.green,
              splashColor: Colors.purple,
              onPressed: press,
            ),
            //Icon(Icons.arrow_forward_ios,),
          ]),
    );
  }
}

import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Account_detailsPage extends StatefulWidget {
  @override
  Account_detailsPageState createState() => Account_detailsPageState();
}

class Account_detailsPageState extends State<Account_detailsPage> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          toolbarHeight: 20,
        ),
        body: Column(children: [
          // Padding(
          //  padding: EdgeInsets.all(20),
          Row(
              // crossAxisAlignment: CrossAxisAlignment.s.start,
              children: [
                Padding(
                    padding: EdgeInsets.fromLTRB(20, 20, 10, 10),
                    child: Text("Account Details",
                        style: Theme.of(context)
                            .textTheme
                            .headline5
                            .copyWith(color: Colors.redAccent))),
              ]),

          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            Padding(
              padding: EdgeInsets.all(5.0),
              child: Text(
                'Name:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  color: Color.fromRGBO(64, 105, 225, 1),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text('Email',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  color: Color.fromRGBO(64, 105, 225, 1),
                )),
          ]),
        ]));
  }
}

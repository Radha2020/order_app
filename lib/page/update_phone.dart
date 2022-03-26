import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

import 'package:order_app/page/account_details.dart';

class Update_phonePage extends StatefulWidget {
  @override
  Update_phonePageState createState() => Update_phonePageState();
}

class Update_phonePageState extends State<Update_phonePage> {
  String phone;
  TextEditingController phoneController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void initState() {
    loaddata();
  }

  void loaddata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      phone = prefs.getString('phone');
      print(phone);
      phoneController.text = phone;
    });
  }

  updatename(phone) async {
    print("phone");
    print(phone);

    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      prefs.setString('phone', phone);
    });
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => Account_detailsPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          toolbarHeight: 20,
        ),
        body: new Form(
            key: _formKey,
            child: Column(children: [
              Row(children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 10, 10),
                ),
              ]),
              Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: TextFormField(
                    autofocus: true,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(
                        color: Colors.blue,
                      ),
                      enabledBorder: new UnderlineInputBorder(
                          borderSide: new BorderSide(color: Colors.blue)),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                    ),
                    controller: phoneController,
                    validator: (value) {
                      if (value.length == 0) {
                        return 'Please enter mobile number';
                      } else if (value.length != 10) {
                        return 'Mobile Number must be of 10 digit';
                      }
                      return null;
                    },
                    //onSaved: (String value) {}
                  )),
              SizedBox(height: 10),
              ElevatedButton(
                  child: new Text("Update"),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                    onPrimary: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      updatename(
                        phoneController.text,
                      );
                    }
                  })
            ])));
  }
}

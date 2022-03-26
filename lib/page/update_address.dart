import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

import 'package:order_app/page/account_details.dart';

class Update_addressPage extends StatefulWidget {
  @override
  Update_addressPageState createState() => Update_addressPageState();
}

class Update_addressPageState extends State<Update_addressPage> {
  String address;
  TextEditingController addressController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  void initState() {
    loaddata();
  }

  void loaddata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      address = prefs.getString('address');
      print(address);
      addressController.text = address;
    });
  }

  updateaddress(address) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(address);

    setState(() {
      prefs.setString('address', address);

      final snackBar = SnackBar(
          backgroundColor: Colors.red, content: Text("Updated successfully"));
      var showSnackBar = ScaffoldMessenger.of(_scaffoldKey.currentContext)
          .showSnackBar(snackBar);

      Navigator.push(context,
          MaterialPageRoute(builder: (context) => Account_detailsPage()));

      print(address);
      // addressController.text = address;
    });
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
                    child: Text("Edit Address",
                        style: Theme.of(context)
                            .textTheme
                            .headline5
                            .copyWith(color: Colors.redAccent))),
              ]),
              Container(
                  // height: 200,
                  //width: 200,
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: TextFormField(
                    controller: addressController,
                    minLines: 4,
                    maxLines: 10,
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
                    // controller: emailController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
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
                  updateaddress(addressController.text);

                  // Navigator.push(context,
                  //    MaterialPageRoute(builder: (context) => SecondPage()));
                },
              )
            ])));
  }
}

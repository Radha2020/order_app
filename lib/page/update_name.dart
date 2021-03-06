import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

import 'package:order_app/page/account_details.dart';

class Update_namePage extends StatefulWidget {
  @override
  Update_namePageState createState() => Update_namePageState();
}

class Update_namePageState extends State<Update_namePage> {
  String name;
  TextEditingController nameController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void initState() {
    loaddata();
  }

  void loaddata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name');
      print(name);
      nameController.text = name;
    });
  }

  updatename(name) async {
    print("name");
    print(name);

    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      prefs.setString('name', name);
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
                    controller: nameController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter some text';
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
                        nameController.text,
                      );
                    }
                  })
            ])));
  }
}

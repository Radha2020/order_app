import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class Update_addressPage extends StatefulWidget {
  @override
  Update_addressPageState createState() => Update_addressPageState();
}

class Update_addressPageState extends State<Update_addressPage> {
  String address;
  TextEditingController addressController = TextEditingController();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          toolbarHeight: 20,
        ),
        body: Column(children: [
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
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextFormField(
                  controller: addressController,
                  decoration: InputDecoration(
                    icon: Icon(Icons.book_online_outlined),
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
                  onSaved: (String value) {
                    // this._data.email = value;
                  })),
        ]));
  }
}

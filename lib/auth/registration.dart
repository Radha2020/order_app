import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
//import 'package:fluttertoast/fluttertoast.dart';
import 'package:order_app/main.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_svg/svg.dart';

Future<String> makePostRequest(email, password, confirmpassword) async {
  await new Future.delayed(const Duration(seconds: 5));
  Register register = Register(email, password);
  String jsonRegister = jsonEncode(register);
  print(jsonRegister);

// set up POST request arguments
  String url = 'http://hospital.impelcreations.co.in/hosp/Api/flut';
  Map<String, String> headers = {"Content-type": "application/json"};

  // String json = '{"title"t
  try {
    http.Response response =
        await http.post(url, headers: headers, body: jsonRegister);
    // check the status code for the result
    //final Map responseJson = json.decode(response.body);

    print(response.body.toString());

    var data = jsonDecode(response.body);
    String status = data["status"];
    if (status == 'success') {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      //prefs.setString('name', n);
      prefs.setString('email', email);
      prefs.setString('password', password);
      // print(prefs.getString('name'));
    }
    //print(response.body.toString());
    // await new Future.delayed(const Duration(seconds: 2));
    // return (response.body.toString());
    return status;
  } catch (err) {
    print('Caught error: $err');
    return err;
  }
}

//else{
// If that call was not successful, throw an error.
// String status="Something Went wrong....";
//return status;
//}
//}
Future<void> _displayResponse(context, res) async {
  if (res == "success") {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            //title: Text('Welcome'),
            // content: Text('$res'),
            content: Text("Welcome to Our Shop"),
            actions: <Widget>[
              new FlatButton(
                child: new Text('OK'),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MyApp()));
                  //Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}

class Register {
  //final String name;
  final String email;
  final String password;

  Register(this.email, this.password);

  Map toJson() => {
        'email': email,
        'password': password,
      };
}

void main() {
  runApp(MaterialApp(
    home: SecondPage(),
  ));
}

class SecondPage extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<SecondPage> {
  TextEditingController confirmpasswordController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  String res = '';
  String password;
  String confirmpassword;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //appBar: AppBar(
        //  backgroundColor: Colors.yellow,
        //   title: Text('Second screen'),
        // ),
        body: Center(
            child: SingleChildScrollView(
                //   child: Padding(
                //     padding: EdgeInsets.all(1),
                child: new Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //CircleAvatar(
                        //radius: 50,
                        Image.asset("assets/logo.png"),
                        //),
                        SizedBox(height: 15),

                        Padding(
                            padding: EdgeInsets.only(
                                bottom: 15, left: 15, right: 15, top: 10),
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  prefixIcon: IconButton(
                                    icon: Icon(Icons.email_outlined),
                                  ),
                                  hintText: 'Email',
                                  contentPadding: const EdgeInsets.all(15),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30))),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter some text';
                                }

                                if (!RegExp(
                                        "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                                    .hasMatch(value)) {
                                  return "Please enter a valid email address";
                                }

                                return null;
                              },
                              controller: emailController,
                            )),
                        Padding(
                          padding: EdgeInsets.only(
                              bottom: 15, left: 15, right: 15, top: 10),
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            obscureText: true,
                            decoration: InputDecoration(
                                prefixIcon: IconButton(
                                  icon: Icon(Icons.lock),
                                ),
                                hintText: 'Password',
                                contentPadding: const EdgeInsets.all(15),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30))),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                            controller: passwordController,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              bottom: 15, left: 15, right: 15, top: 15),
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            obscureText: true,
                            decoration: InputDecoration(
                                prefixIcon: IconButton(
                                  icon: Icon(Icons.lock),
                                ),
                                hintText: 'Confirm Password',
                                contentPadding: const EdgeInsets.all(15),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30))),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter some text';
                              }
                              if (passwordController.text !=
                                  confirmpasswordController.text) {
                                return 'password does not match';
                              }
                              return null;
                            },
                            controller: confirmpasswordController,
                          ),
                        ),
                        Container(
                          height: 50,
                          padding:
                              EdgeInsets.only(top: 20, left: 20, right: 20),
                          child: RaisedButton(
                            textColor: Colors.white,
                            color: Colors.deepOrangeAccent,
                            child: Text('Submit'),

                            onPressed: () async {
                              //       print(nameController.text);
                              //     print(passwordController.text);

                              if (_formKey.currentState.validate()) {
                                BuildContext dialogContext;
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    dialogContext = context;
                                    return Dialog(
                                      child: Container(
                                        //  padding:EdgeInsets.fromLTRB(10, 10, 10, 0),
                                        width: 20.0,
                                        height: 70.0,

                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            CircularProgressIndicator(),
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(left: 20),
                                              child: Text('Please Wait!'),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                                String res = await makePostRequest(
                                        emailController.text,
                                        passwordController.text,
                                        confirmpasswordController.text)
                                    .whenComplete(
                                        () => Navigator.pop(dialogContext));

                                await _displayResponse(context, res);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MyApp()));

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MyApp()));
                              }
                            },
                            //makePostRequest(nameController.text,emailController.text,passwordController.text);
                          ),
                        ),
                      ],
                    )))));
  }
}

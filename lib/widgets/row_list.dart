import 'package:flutter/material.dart';

import 'package:order_app/services/Services.dart';
import 'package:order_app/model/category.dart';
import 'package:order_app/model/mybanner.dart';

class MyApp extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<MyApp> {
  String _categoryid;
  String _category;
  List<Category> categoryList = [];
  List<MyBanner> bannerList = [];

  void initState() {
    Services.fetchCategory().then((categoriesFromServer) {
      setState(() {
        categoryList = categoriesFromServer;
        print(categoryList.length);
        _category = "All";
        //_enabled = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Container(
        height: 115,
        child: ListView.builder(
            itemCount: categoryList.length,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            //physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Column(children: [
                Container(
                  padding: EdgeInsets.all(17),
                  margin: EdgeInsets.only(top: 5, bottom: 2, left: 7, right: 5),
                  height: 90,
                  width: 90,
                  child: InkWell(
                      onTap: () async {
                        print("image clicked");
                        _categoryid = categoryList[index].catid;
                        _category = categoryList[index].title;
                        Services.fetchProductsPerId(_categoryid)
                            .then((categoriesFromServer) {
                          setState(() {
                            bannerList = categoriesFromServer;
                            //print(categoryList.length);
                          });
                        }); /*setState(() {
                                _categoryid = categoryList[index]
                                    .catid; //if you want to assign the index somewhere to check
                              });*/
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: 70.0,
                        backgroundImage: NetworkImage(
                          categoryList[index].imageUrl,
                        ),
                      )),
                ),
                Text(categoryList[index].title,
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2
                        .copyWith(fontWeight: FontWeight.bold))
              ]);
            }));
  }
}

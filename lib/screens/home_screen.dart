import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// class HomeScreen extends StatefulWidget {
//   static const routeName = '/home';
//   @override
//   HomeState createState() => HomeState();
// }

// ignore: must_be_immutable
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  dynamic data;
  String reqElementSearch = "a";
  int currentPage = 0;
  int totalPages = 0;
  int pageSize = 20;
  ScrollController scrollController = ScrollController();
  List<dynamic> userItems = [];
  TextEditingController elementSearch = TextEditingController();

  void users(String req) {
    String url1 =
        // ignore: unnecessary_brace_in_string_interps
        "https://api.github.com/search/users?q=${req}&per_page=$pageSize&page=$currentPage";
    // String url 2= 'https://api.github.com/users?per_page=1000&page=0';
    print(url1);
    http.get(Uri.parse(url1)).then((response) {
      setState(() {
        data = jsonDecode(response.body);
        userItems.addAll(data['items']);
        if (data["total_count"] % pageSize == 0) {
          totalPages = data["total_count"] ~/ pageSize;
        } else {
          totalPages = (data["total_count"] / pageSize).floor() + 1;
        }
      });
    }).catchError((err) {
      print(err);
    });
  }

  @override
  void initState() {
    super.initState();
    users(reqElementSearch);
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        setState(() {
          if (currentPage < totalPages - 1) {
            ++currentPage;
            users(reqElementSearch);
          }
        });
      }
    });
    // users();
  }

  @override
  Widget build(BuildContext context) {
    print("Page Lancé");
    return Scaffold(
      drawer: Drawer(),
      appBar: AppBar(
        title: Text("B2K GITHUB"),
        elevation: 10,
      ),
      body: Container(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: TextFormField(
                      controller: elementSearch,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(left: 20),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                              color: Colors.red,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(30))),
                      ),
                      onFieldSubmitted: (String value) {
                        print(value);
                        userItems = [];
                        currentPage = 0;
                        reqElementSearch = value;
                        users(reqElementSearch);
                      },
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.search,
                  ),
                  onPressed: () {
                    // $currentPage/$totalPages
                    setState(() {
                      print(reqElementSearch);
                      userItems = [];
                      currentPage = 0;
                      reqElementSearch = elementSearch.text;
                      users(reqElementSearch);
                    });
                  },
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                  controller: scrollController,
                  itemCount: userItems.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(
                                    userItems[index]["avatar_url"]),
                                radius: 30,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text(userItems[index]["login"]),
                            ],
                          ),
                          CircleAvatar(
                            child: Text(userItems[index]["score"].toString()),
                          ),
                        ],
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

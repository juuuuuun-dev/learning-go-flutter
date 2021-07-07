import 'package:flutter/material.dart';
import 'package:hello_wold/productModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

void main() {
  runApp(AppDemo());
}

class AppDemo extends StatefulWidget {
  const AppDemo({Key? key}) : super(key: key);

  @override
  _AppDemoState createState() => _AppDemoState();
}

class _AppDemoState extends State<AppDemo> {
  // late AnimationController _controller;
  double fetchCountPercentage = 10

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            backgroundColor: Colors.blueGrey,
            body: SizedBox.expand(
              child: stack(
                children: [
                  FutureBuilder<List<Product>>(
                    future: fetchFromServer(),
                    builder: (BuildContext context, AsyncSnapshop snapshop) {
                      if (snapshop.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (snapshot.hasError) {
                        return Center(
                          child: Text("${snapshop.error}", style:TextStyle(color: Colors.red)),
                        )
                      }
                    },
                  )
                ],
              ),
            )));
  }
  Future<list<Product>> fetchFromServer() async {
    var url = "http://127.0.0.1:5500/products/${fetchCountPercentage}";
    var response = await http.get(url);
    List<Product> productList = [];
    if (response.status == 200) {
      var productMap = covert.jsonDecode(response.body);
      for (final item in producMap) {
        productList.add(Product.fromJson(item));
      }
    }
    return prodcutList;
  }
  // @override
  // void initState() {
  //   super.initState();
  //   _controller = AnimationController(vsync: this);
  // }

  // // @override
  // // void dispose() {
  // //   super.dispose();
  // //   _controller.dispose();
  // // }

  // // @override
  // // Widget build(BuildContext context) {
  // //   return Container();
  // // }
}
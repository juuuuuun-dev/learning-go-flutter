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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        home: Scaffold(
            backgroundColor: Colors.grey[100],
            body: SizedBox.expand(
              child: Stack(
                children: [
                  FutureBuilder<List<Product>>(
                      future: fetchFromServer(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (snapshot.hasError) {
                          return Center(
                            child: Text("${snapshot.error}",
                                style: TextStyle(color: Colors.red)),
                          );
                        }
                        if (snapshot.hasData) {
                          return ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Card(
                                  child: ListTile(
                                title: Text(snapshot.data[index].name),
                                subtitle: Text(
                                    "Count: ${snapshot.data[index].count} \t Price: ${snapshot.data[index].price}"),
                              ));
                            },
                          );
                        }
                        return Container();
                      })
                ],
              ),
            )));
  }

  Future<List<Product>> fetchFromServer() async {
    var fetchCountPercentage = 110;
    var url = "http://192.168.11.2:5500/products/${fetchCountPercentage}";
    var response = await http.get(Uri.parse(url));
    List<Product> productList = [];
    if (response.statusCode == 200) {
      debugPrint("${fetchCountPercentage.round()}");
      var productMap = convert.jsonDecode(response.body);
      for (final item in productMap) {
        productList.add(Product.fromJson(item));
      }
    }
    return productList;
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

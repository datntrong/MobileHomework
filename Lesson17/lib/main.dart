// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'product.dart';

void main() {
  runApp(MyApp(
    products: fetchProducts(),
  ));
}

List<Product> parseProduct(http.Response response) {
  final parsed =
      json.decode(utf8.decode(response.bodyBytes)).cast<Map<String, dynamic>>();

  return parsed.map<Product>((json) => Product.fromMap(json)).toList();
}

Future<List<Product>> fetchProducts() async {
  final response =
      await http.get(Uri.parse('http://192.168.1.16:8000/products.json'));

  if (response.statusCode == 200) {
    return parseProduct(response);
  } else {
    throw Exception('Unable to fetch products from the REST API');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.products}) : super(key: key);
  final Future<List<Product>> products;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Lesson 17', products: products),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title, required this.products})
      : super(key: key);
  final String title;
  final Future<List<Product>> products;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: FutureBuilder<List<Product>>(
          future: widget.products,
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);
            return snapshot.hasData
                ? ProductBoxList(items: snapshot.data!)
                : const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}

class RatingBox extends StatefulWidget {
  const RatingBox({Key? key}) : super(key: key);

  @override
  _RatingBoxState createState() => _RatingBoxState();
}

class _RatingBoxState extends State<RatingBox> {
  int _rating = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [1, 2, 3]
          .map(
            (i) => IconButton(
              onPressed: () {
                setState(() {
                  _rating = i;
                });
              },
              icon: _rating >= i
                  ? const Icon(Icons.star)
                  : const Icon(Icons.star_border),
              color: Colors.amber,
            ),
          )
          .toList(),
    );
  }
}

class ProductBox extends StatelessWidget {
  const ProductBox({Key? key, required this.item}) : super(key: key);

  final Product item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2),
      height: 140,
      child: Card(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Image.asset(
            "assets/appimages/" + item.image,
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(item.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      )),
                  Text(item.description),
                  Text("Price: " + item.price.toString()),
                  const Padding(
                    padding: EdgeInsets.only(left: 35),
                    child: RatingBox(),
                  )
                ],
              ),
            ),
          )
        ],
      )),
    );
  }
}

class ProductPage extends StatelessWidget {
  const ProductPage({Key? key, required this.item}) : super(key: key);
  final Product item;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item.name),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Image.asset(
                "assets/appimages/" + item.image,
                height: 100.0,
                width: MediaQuery.of(context).size.width,
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(
                        item.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(item.description),
                      Text("Price: " + item.price.toString()),
                      const Padding(
                        padding: EdgeInsets.only(left: 130),
                        child: RatingBox(),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ProductBoxList extends StatelessWidget {
  const ProductBoxList({Key? key, required this.items}) : super(key: key);
  final List<Product> items;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          child: ProductBox(item: items[index]),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductPage(item: items[index]),
              ),
            );
          },
        );
      },
    );
  }
}

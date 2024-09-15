import 'package:ecom/productdetail.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(ProductListPage());
}

class ProductListPage extends StatefulWidget {
  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  List products = [];

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    final response =
        await http.get(Uri.parse('https://dummyjson.com/products'));
    if (response.statusCode == 200) {
      setState(() {
        products = json.decode(response.body)['products'];
      });
    } else {
      throw Exception('Failed to load products');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Products'),
          backgroundColor: const Color.fromARGB(255, 126, 0, 165),
          foregroundColor: Colors.white,
        ),
        body: ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    padding: EdgeInsets.all(20),
                    height: 410,
                    width: 300,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromARGB(255, 209, 170, 221),
                          blurRadius: 20,
                          offset: Offset(8, 10),
                        ),
                      ],
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        Center(
                          child: Container(
                            height: 250,
                            width: 250,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              image: DecorationImage(
                                  image: NetworkImage(
                                      products[index]['thumbnail']),
                                  fit: BoxFit.cover),
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              products[index]['title'],
                              style: TextStyle(
                                fontSize: 15,
                                color: Color.fromARGB(255, 126, 0, 165),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '\$' + products[index]['price'].toString(),
                              style: TextStyle(
                                color: Color.fromARGB(255, 126, 0, 165),
                                fontSize: 20,
                              ),
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  color:
                                      const Color.fromARGB(255, 255, 209, 59),
                                ),
                                Text(
                                  products[index]['rating'].toString(),
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 126, 0, 165),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailsPage(
                      product: products[index],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

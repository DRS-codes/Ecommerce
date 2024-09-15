import 'package:ecom/added.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ProductDetailsPage extends StatelessWidget {
  final Map product;

  ProductDetailsPage({required this.product});

  Future<void> addToCart(Map product) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? cartItems = prefs.getStringList('cart') ?? [];

    cartItems.add(json.encode(product));
    await prefs.setStringList('cart', cartItems);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product['title'])),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(20),
          height: MediaQuery.of(context).size.height * 0.8,
          width: MediaQuery.of(context).size.width * 0.8,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(255, 209, 170, 221),
                blurRadius: 20,
                offset: Offset(8, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 200,
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(
                        product['thumbnail'],
                      ),
                      fit: BoxFit.cover),
                ),
              ),
              Text(
                product['title'],
                style: TextStyle(
                  color: Color.fromARGB(255, 126, 0, 165),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '\$' + product['price'].toString(),
                style: TextStyle(
                  color: Color.fromARGB(255, 126, 0, 165),
                  fontSize: 25,
                ),
              ),
              Text(
                product['description'].toString(),
                style: TextStyle(
                  color: Color.fromARGB(255, 126, 0, 165),
                  fontSize: 13,
                ),
              ),
              Row(
                children: [
                  Icon(
                    Icons.star,
                    color: const Color.fromARGB(255, 255, 186, 59),
                  ),
                  Text(
                    product['rating'].toString(),
                    style: TextStyle(
                      color: Color.fromARGB(255, 126, 0, 165),
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 40,
              ),
              ElevatedButton(
                onPressed: () async {
                  await addToCart(product);
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('Added to cart!')));
                },
                child: Text('Add to Cart'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CartPage()),
          );
        },
        child: Icon(Icons.shopping_cart),
      ),
    );
  }
}

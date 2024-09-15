import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<Map> cartItems = [];

  @override
  void initState() {
    super.initState();
    loadCart();
  }

  Future<void> loadCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? cartList = prefs.getStringList('cart') ?? [];

    // Map each item in cartList to Map<dynamic, dynamic> by decoding it
    setState(() {
      cartItems = cartList
          .map((item) => Map<String, dynamic>.from(json.decode(item)))
          .toList();
    });
  }

  Future<void> removeFromCart(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? cartList = prefs.getStringList('cart') ?? [];

    cartList.removeAt(index);
    await prefs.setStringList('cart', cartList);

    loadCart();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Cart (${cartItems.length})'),
          backgroundColor: Color.fromARGB(255, 126, 0, 165),
          foregroundColor: Colors.white,
        ),
        body: ListView.builder(
          itemCount: cartItems.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    padding: EdgeInsets.all(20),
                    height: 450,
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
                                      cartItems[index]['thumbnail']),
                                  fit: BoxFit.cover),
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cartItems[index]['title'],
                              style: TextStyle(
                                fontSize: 15,
                                color: Color.fromARGB(255, 126, 0, 165),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '\$' + cartItems[index]['price'].toString(),
                              style: TextStyle(
                                color: Color.fromARGB(255, 126, 0, 165),
                                fontSize: 20,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.star,
                                      color: const Color.fromARGB(
                                          255, 255, 209, 59),
                                    ),
                                    Text(
                                      cartItems[index]['rating'].toString(),
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 126, 0, 165),
                                      ),
                                    ),
                                  ],
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.remove_circle,
                                    color: Color.fromARGB(255, 126, 0, 165),
                                  ),
                                  onPressed: () {
                                    removeFromCart(index);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:swe2109772_assignment1/models/item_model.dart';
import 'package:swe2109772_assignment1/database/db_service.dart';

class CartPage extends StatefulWidget {
  final List<Item> cartItems;
  final Function(List<Item>) updateCartItems;

  CartPage({required this.cartItems, required this.updateCartItems});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  void _increaseQuantity(Item item) async {
    setState(() {
      item.quantity += 1;
    });
    await DatabaseService.addCartItem(item);
    widget.updateCartItems(widget.cartItems);
  }

  void _decreaseQuantity(Item item) async {
    if (item.quantity > 1) {
      setState(() {
        item.quantity -= 1;
      });
      await DatabaseService.addCartItem(item);
      widget.updateCartItems(widget.cartItems);
    }
  }

  void _removeFromCart(Item item) async {
    setState(() {
      widget.cartItems.remove(item);
    });
    await DatabaseService.deleteCartItem(item);
    widget.updateCartItems(widget.cartItems);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Cart',
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.w500,
            fontFamily: 'NotoSerif'
          ),
        ),
        backgroundColor: HexColor("#212A91"),
        centerTitle: true,
      ),
      body: widget.cartItems.isEmpty
          ? Center(
            child: Text(
              'Your cart list is empty.',
              style: TextStyle(
              color: Colors.grey[800],
              fontSize: 25,
              ),
            ),
          )
          : ListView.builder(
            itemCount: widget.cartItems.length,
            itemBuilder: (context, index) {
              final item = widget.cartItems[index];
              final itemPrice = double.parse(item.price.replaceAll(RegExp(r'[^\d.]'), ''));
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1.0),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: ListTile(
                  leading: Container(
                    width: 70, // Adjust the width as needed
                    height: 100, // Set the height to match the parent container
                      child: Image.asset(
                        item.imgPath,
                        fit: BoxFit.cover,
                      ),
                  ),
                  title: Text(
                    item.name,
                    style: TextStyle(
                      fontSize: 19,
                      fontFamily: 'NotoSerif'// Adjust the font size as needed
                    ),
                  ),
                  subtitle: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () => _decreaseQuantity(item),
                      ),
                      Text(
                        '${item.quantity}',
                        style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'NotoSerif'
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () => _increaseQuantity(item),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _removeFromCart(item),
                      )
                    ],
                  ),
                  trailing: Text(
                    'RM${(item.quantity * itemPrice).toStringAsFixed(2)}',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'NotoSerif'
                    ),
                  ),
                ),
              )
              );
            },
          ),
    );
  }
}

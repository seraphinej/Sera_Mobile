import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:swe2109772_assignment1/models/item_model.dart';
import 'package:swe2109772_assignment1/database/db_service.dart';

class CartPage extends StatefulWidget {
  final Function(List<Item>) updateCartItems;

  CartPage({required this.updateCartItems});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<Item> _cartItems = [];

  @override
  void initState() {
    super.initState();
    _loadCartItems();
  }

  Future<void> _loadCartItems() async {
    final cartItems = await DatabaseService.getCartItems();
    setState(() {
      _cartItems = cartItems;
    });
  }

  void _increaseQuantity(Item item) async {
    setState(() {
      item.quantity += 1;
    });
    await DatabaseService.addCartItem(item);
    // Update parent widget or other parts of the app with updated cart items
    widget.updateCartItems(_cartItems);
  }

  void _decreaseQuantity(Item item) async {
    if (item.quantity > 1) {
      setState(() {
        item.quantity -= 1;
      });
      await DatabaseService.addCartItem(item);
      widget.updateCartItems(_cartItems);
    }
  }

  void _removeFromCart(Item item) async {
    setState(() {
      _cartItems.remove(item);
    });
    await DatabaseService.deleteCartItem(item);
    widget.updateCartItems(_cartItems);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Cart',
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.w500,
            fontFamily: 'NotoSerif',
          ),
        ),
        backgroundColor: HexColor("#212A91"),
        centerTitle: true,
      ),
      body: _cartItems.isEmpty
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
        itemCount: _cartItems.length,
        itemBuilder: (context, index) {
          final item = _cartItems[index];
          final itemPrice =
          double.parse(item.price.replaceAll(RegExp(r'[^\d.]'), ''));
          return Padding(
            padding: const EdgeInsets.symmetric(
                vertical: 10, horizontal: 10.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1.0),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: ListTile(
                leading: Container(
                  width: 70,
                  height: 100,
                  child: Image.asset(
                    item.imgPath,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(
                  item.name,
                  style: TextStyle(
                    fontSize: 19,
                    fontFamily: 'NotoSerif',
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
                        fontFamily: 'NotoSerif',
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () => _increaseQuantity(item),
                    ),
                    Expanded(
                      child: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _removeFromCart(item),
                      ),
                    )
                  ],
                ),
                trailing: Text(
                  'RM${(item.quantity * itemPrice).toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'NotoSerif',
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:swe2109772_assignment1/models/item_model.dart';
import 'package:swe2109772_assignment1/models/category_model.dart';
import 'package:swe2109772_assignment1/screens/favorite_page.dart';
import 'package:swe2109772_assignment1/screens/cart_page.dart';

class ItemDetailsPage extends StatefulWidget {
  final Item item;
  final Function(Item) addToCart;

  const ItemDetailsPage({super.key, required this.item, required this.addToCart});

  @override
  State<ItemDetailsPage> createState() => _ItemDetailsPageState();
}

class _ItemDetailsPageState extends State<ItemDetailsPage> {
  List<CategoryModel> categories = [];
  List<Item> popularItems = [];
  List<Item> favoriteItems = [];
  List<Item> cartItems = [];

  @override
  void initState() {
    super.initState();
  }

  void addToCart(Item item) {
    setState(() {
      cartItems.add(item);
      widget.addToCart(item);
    });
  }

  /*void toggleFavorite(Item item) {
    setState(() {
      widget.item.isFavorited = !widget.item.isFavorited;
      if (item.isFavorited) {
        favoriteItems.add(item);
      } else {
        favoriteItems.remove(item);
      }
    });
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.item.name,
          style: TextStyle(
            fontSize: 25,
            fontFamily: 'NotoSerif',
            color: Colors.white
          ),
        ),
        backgroundColor: HexColor('#212A91'),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    widget.item.imgPath,
                    width: double.infinity,
                    height: 300,
                    fit: BoxFit.fill,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  widget.item.name,
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'NotoSerif'
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.item.price,
                  style: const TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'NotoSerif'
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.item.description,
                  textAlign: TextAlign.justify,
                  style: const TextStyle(
                    fontSize: 17,
                    fontFamily: 'NotoSerif',
                    fontWeight: FontWeight.w300
                  ),
                ),
                SizedBox(height: 80),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  addToCart(widget.item);
                },
                child: Text(
                  'Add to Cart',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'NotoSerif',
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50), // Full width button
                  backgroundColor: HexColor("#212A91"),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

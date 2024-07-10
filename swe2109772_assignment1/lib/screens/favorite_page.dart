import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:swe2109772_assignment1/models/item_model.dart';
import 'package:swe2109772_assignment1/database/db_service.dart';
import 'package:swe2109772_assignment1/screens/item_detail_page.dart';

class FavoritePage extends StatefulWidget {
  final List<Item> cartItems;
  final Function(List<Item>) updateFavoriteItems;
  final Function(List<Item>) updateCartItems;

  FavoritePage({
    required this.cartItems,
    required this.updateFavoriteItems,
    required this.updateCartItems,
  });

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  List<Item> _favoriteItems = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final favorites = await DatabaseService.getFavorites();
    setState(() {
      _favoriteItems = favorites;
    });
  }

  Future<void> _removeFavorite(Item item) async {
    setState(() {
      _favoriteItems.remove(item);
    });
    await DatabaseService.deleteFavorite(item);
    widget.updateFavoriteItems(_favoriteItems);
  }

  void addToCart(Item item) {
    final existingItemIndex = widget.cartItems.indexWhere(
          (cartItem) =>
      cartItem.name == item.name &&
          cartItem.imgPath == item.imgPath &&
          cartItem.price == item.price &&
          cartItem.description == item.description,
    );

    setState(() {
      if (existingItemIndex != -1) {
        widget.cartItems[existingItemIndex].quantity += 1;
      } else {
        widget.cartItems.add(Item(
          name: item.name,
          imgPath: item.imgPath,
          price: item.price,
          description: item.description,
          quantity: 1,
        ));
      }
    });
    widget.updateCartItems(widget.cartItems);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Favorites',
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
      body: _favoriteItems.isEmpty
          ? Center(
        child: Text(
          'Your favorite list is empty.',
          style: TextStyle(
            color: Colors.grey[800],
            fontSize: 25,
          ),
        ),
      )
          : ListView.builder(
        itemCount: _favoriteItems.length,
        itemBuilder: (context, index) {
          final item = _favoriteItems[index];
          return Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 14.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1.0),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: ListTile(
                  leading: Image.asset(item.imgPath, width: 70, height: 70),
                  title: Text(
                    item.name,
                    style: const TextStyle(
                        fontSize: 20,
                        fontFamily: 'NotoSerif'
                    ),
                  ),
                  subtitle: Text(
                    item.price,
                    style: const TextStyle(
                        fontSize: 18,
                        fontFamily: 'NotoSerif'
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(
                        item.isFavorited
                            ? Icons.favorite
                            : Icons.favorite_outline,
                        color: Colors.red
                    ),
                    onPressed: () => _removeFavorite(item),
                  ),
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ItemDetailsPage(
                            item: _favoriteItems[index],
                            addToCart: addToCart
                        ),
                      ),
                    );
                  },
                ),
              )
          );
        },
      ),
    );
  }
}

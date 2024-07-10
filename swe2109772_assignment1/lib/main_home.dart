import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:swe2109772_assignment1/models/item_model.dart';
import 'package:swe2109772_assignment1/screens/cart_page.dart';
import 'package:swe2109772_assignment1/screens/favorite_page.dart';
import 'package:swe2109772_assignment1/screens/home_page.dart';
import 'package:swe2109772_assignment1/screens/profile_page.dart';
import 'package:swe2109772_assignment1/database/db_service.dart';

import 'category_screens/coffee_page.dart';

class MainHomePage extends StatefulWidget{
  const MainHomePage({Key? key}) : super(key: key);

  @override
  State<MainHomePage> createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage>{
  int myCurrentIndex = 0;
  List<Item> favoriteItems=[];
  List<Item> cartItems = [];

  @override
  void initState() {
    super.initState();
    _loadCartItems();
  }

  Future<void> _loadCartItems() async {
    final items = await DatabaseService.getCartItems();
    setState(() {
      cartItems = items;
    });
  }

  void updateFavoriteItems(List<Item> items) {
    setState(() {
      favoriteItems = items;
    });
  }

  void updateCartItems(List<Item> items) async {
    setState(() {
      cartItems = items;
    });
    for (var item in items) {
      await DatabaseService.addCartItem(item);
    }
  }

  @override
  Widget build(BuildContext context){
    final pages = [
      HomePage(
        favoriteItems: favoriteItems,
        cartItems: cartItems,
        updateFavoriteItems: updateFavoriteItems,
        updateCartItems: updateCartItems,
      ),
      FavoritePage(cartItems: cartItems, updateFavoriteItems: updateFavoriteItems, updateCartItems: updateCartItems),
      CartPage(updateCartItems: updateCartItems,),
      ProfilePage()
    ];

    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: HexColor("#212A91"),
          unselectedItemColor: Colors.grey,
          currentIndex: myCurrentIndex,
          backgroundColor: Colors.white,
          onTap: (index){
            setState(() {
              myCurrentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_filled),
                label: 'Home'
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.favorite_outlined),
                label: 'Favorite'
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart),
                label: 'Cart'
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile'
            ),
          ],
        ),
      body: pages[myCurrentIndex],
    );
  }
}
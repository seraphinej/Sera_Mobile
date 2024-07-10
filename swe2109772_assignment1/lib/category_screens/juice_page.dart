import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:swe2109772_assignment1/models/item_model.dart';
import 'package:swe2109772_assignment1/screens/item_detail_page.dart';
import 'package:swe2109772_assignment1/screens/favorite_page.dart';
import 'package:swe2109772_assignment1/screens/cart_page.dart';
import 'package:swe2109772_assignment1/database/db_service.dart';

class JuicePage extends StatefulWidget {
  final List<Item> favoriteItems;
  final List<Item> cartItems;
  final Function(List<Item>) updateFavoriteItems;
  final Function(List<Item>) updateCartItems;

  const JuicePage({
    super.key,
    required this.favoriteItems,
    required this.cartItems,
    required this.updateFavoriteItems,
    required this.updateCartItems
  });

  @override
  State<JuicePage> createState() => _JuicePageState();
}

class _JuicePageState extends State<JuicePage> {
  List<Item> juiceItem = [];
  List<Item> favoriteItems = [];
  List<Item> cartItems = [];

  @override
  void initState() {
    super.initState();
    favoriteItems = widget.favoriteItems;
    _getInitialInfo();
  }

  void _getInitialInfo() async{
    juiceItem = Item.getJuiceItem();
    favoriteItems = await DatabaseService.getFavorites();
    setState(() {});
  }

  void toggleFavorite(Item item) async {
    setState(() {
      item.isFavorited = !item.isFavorited;
      if (item.isFavorited) {
        favoriteItems.add(item);
      } else {
        favoriteItems.removeWhere((i) => i.name == item.name && i.imgPath == item.imgPath);
      }
    });

    await DatabaseService.updateFavoriteStatus(item);
    widget.updateFavoriteItems(favoriteItems);
  }

  void addToCart(Item item) {
    final existingItemIndex = widget.cartItems.indexWhere(
            (cartItem) =>
        cartItem.name == item.name &&
            cartItem.imgPath == item.imgPath &&
            cartItem.price == item.price &&
            cartItem.description == item.description);

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
          'Juice',
          style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.w500,
              fontFamily: 'NotoSerif'
          ),
        ),
        backgroundColor: HexColor("#212A91"),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 40, left: 20, right: 20),
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12.withOpacity(0.10),
                      blurRadius: 30
                  )
                ]
            ),
            child: TextField(
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.all(15),
                  hintText: 'Search Here',
                  hintStyle: const TextStyle(
                      color: Colors.grey,
                      fontSize: 16
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none
                  ),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: SvgPicture.asset('assets/icons/Search.svg'),
                  )
              ),
            ),
          ),
          const SizedBox(height: 30),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2
                ),
                itemCount: juiceItem.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final item = juiceItem[index];
                  item.isFavorited = favoriteItems.any((favItem) =>
                  favItem.name == item.name && favItem.imgPath == item.imgPath);
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ItemDetailsPage(
                              item: juiceItem[index],
                              addToCart: addToCart
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const[
                          BoxShadow(
                              color: Colors.grey,
                              blurRadius: 4,
                              spreadRadius: 2
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ClipRRect(
                            child: Image.asset(
                              item.imgPath,
                              width: 150,
                              height: 90,
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                          Text(
                            item.name,
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'NotoSerif',
                                color: Colors.black
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                item.price,
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'NotoSerif',
                                    color: Colors.black
                                ),
                              ),
                              Container(
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle
                                ),
                                child: IconButton(
                                    onPressed: () {
                                      toggleFavorite(item);
                                    },
                                    icon: Icon(
                                      item.isFavorited
                                          ? Icons.favorite
                                          : Icons.favorite_outline,
                                      color: Colors.red,
                                    )
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              )
            ],
          )
        ],
      ),
    );
  }
}

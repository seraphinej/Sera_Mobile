import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:swe2109772_assignment1/category_screens/pastry_page.dart';
import 'package:swe2109772_assignment1/category_screens/coffee_page.dart';
import 'package:swe2109772_assignment1/category_screens/juice_page.dart';
import 'package:swe2109772_assignment1/category_screens/noncoffee_page.dart';
import 'package:swe2109772_assignment1/screens/item_detail_page.dart';
import 'package:swe2109772_assignment1/models/category_model.dart';
import 'package:swe2109772_assignment1/models/item_model.dart';
import 'package:swe2109772_assignment1/database/db_service.dart';
import 'package:video_player/video_player.dart';

class HomePage extends StatefulWidget {
  final List<Item> favoriteItems;
  final List<Item> cartItems;
  final Function(List<Item>) updateFavoriteItems;
  final Function(List<Item>) updateCartItems;

  const HomePage({
    super.key,
    required this.favoriteItems,
    required this.cartItems,
    required this.updateFavoriteItems,
    required this.updateCartItems,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<CategoryModel> categories = [];
  List<Item> popularItems = [];
  List<Item> favoriteItems = [];
  late VideoPlayerController _videoPlayerController;

  @override
  void initState() {
    super.initState();
    favoriteItems = widget.favoriteItems;
    _videoPlayerController = VideoPlayerController.asset(
      'assets/videos/cafeteria_video.mp4',
    )
      ..initialize().then((_) {
        setState(() {}); // Ensure the UI is updated after initialization
        _videoPlayerController.play();
      });
    _getInitialInfo();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  void _getInitialInfo() async {
    categories = CategoryModel.getCategories();
    popularItems = Item.getPopularItems();
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
      appBar: appBar(),
      body: ListView(
        children: [
          _searchField(),
          const SizedBox(height: 30),
          _categorySection(),
          const SizedBox(height: 30),
          _videoSection(),
          const SizedBox(height: 30),
          _popularSection(),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      title: const Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 5),
          Row(
            children: [
              Icon(
                Icons.location_pin,
                size: 23,
                color: Colors.white,
              ),
              SizedBox(width: 10),
              Text(
                'Coffee Code',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'NotoSerif'
                ),
              )
            ],
          ),
        ],
      ),
      backgroundColor: HexColor("#212A91"),
      centerTitle: false,
    );
  }

  Container _searchField() {
    return Container(
      margin: const EdgeInsets.only(top: 40, left: 20, right: 20),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.10),
            blurRadius: 30,
          )
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.all(15),
          hintText: 'Search Here',
          hintStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.all(12.0),
            child: SvgPicture.asset('assets/icons/Search.svg'),
          ),
        ),
      ),
    );
  }

  SingleChildScrollView _categorySection() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20),
            child: Text(
              'Category',
              style: TextStyle(
                color: HexColor("#212A91"),
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'NotoSerif'
              ),
            ),
          ),
          const SizedBox(height: 15),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCategoryItem(
                  'Coffee',
                  'assets/images/coffee.png',
                  CoffeePage(
                    favoriteItems: widget.favoriteItems,
                    updateFavoriteItems: widget.updateFavoriteItems,
                    cartItems: widget.cartItems,
                    updateCartItems: widget.updateCartItems,
                  ),
                ),
                _buildCategoryItem(
                  'Non-Coffee',
                  'assets/images/bubble tea.png',
                  NonCoffeePage(
                    favoriteItems: widget.favoriteItems,
                    updateFavoriteItems: widget.updateFavoriteItems,
                    cartItems: widget.cartItems,
                    updateCartItems: widget.updateCartItems,
                  ),
                ),
                _buildCategoryItem(
                  'Juice',
                  'assets/images/juice.png',
                  JuicePage(
                    favoriteItems: widget.favoriteItems,
                    updateFavoriteItems: widget.updateFavoriteItems,
                    cartItems: widget.cartItems,
                    updateCartItems: widget.updateCartItems,
                  ),
                ),
                _buildCategoryItem(
                  'Pastry',
                  'assets/images/cake.png',
                  PastryPage(
                    favoriteItems: widget.favoriteItems,
                    updateFavoriteItems: widget.updateFavoriteItems,
                    cartItems: widget.cartItems,
                    updateCartItems: widget.updateCartItems,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  InkWell _buildCategoryItem(String title, String imagePath, Widget destinationPage) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => destinationPage,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(5),
        width: 120,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: 100,
              height: 80,
              decoration: BoxDecoration(
                color: HexColor("#2596be").withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Image.asset(imagePath),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 18,
                fontFamily: 'NotoSerif',
                color: Colors.black,
              ),
            )
          ],
        ),
      ),
    );
  }

  Column _popularSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text(
            'Our Popular Items',
            style: TextStyle(
              color: HexColor("#212A91"),
              fontSize: 20,
              fontWeight: FontWeight.w600,
              fontFamily: 'NotoSerif'
            ),
          ),
        ),
        const SizedBox(height: 10),
        GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10.0,
          ),
          itemCount: popularItems.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final item = popularItems[index];
            item.isFavorited = favoriteItems.any(
                  (favItem) =>
              favItem.name == item.name && favItem.imgPath == item.imgPath,
            );
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ItemDetailsPage(
                      item: popularItems[index],
                      addToCart: addToCart,
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
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 4,
                      spreadRadius: 2,
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
                        color: Colors.black,
                        fontFamily: 'NotoSerif'
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
                            color: Colors.black,
                          ),
                        ),
                        Container(
                          decoration: const BoxDecoration(shape: BoxShape.circle),
                          child: IconButton(
                            onPressed: () {
                              toggleFavorite(item);
                            },
                            icon: Icon(
                              item.isFavorited
                                  ? Icons.favorite
                                  : Icons.favorite_outline,
                              color: Colors.red,
                            ),
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
    );
  }

  Column _videoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text(
            'Discover Our Cafeteria',
            style: TextStyle(
              color: HexColor("#212A91"),
              fontSize: 20,
              fontWeight: FontWeight.w600,
              fontFamily: 'NotoSerif'
            ),
          ),
        ),
        const SizedBox(height: 10,),
        _videoPlayerController.value.isInitialized
            ? AspectRatio(
              aspectRatio: _videoPlayerController.value.aspectRatio,
              child: VideoPlayer(_videoPlayerController),
              )
            : Container(
                height: 200,
                color: Colors.black,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
        const SizedBox(height: 20),
        VideoProgressIndicator(
          _videoPlayerController,
          allowScrubbing: true,
          colors: const VideoProgressColors(
            backgroundColor: Colors.red,
            bufferedColor: Colors.black,
            playedColor: Colors.blueAccent,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                _videoPlayerController.pause();
              },
              icon: const Icon(Icons.pause),
            ),
            const SizedBox(width: 10),
            IconButton(
              onPressed: () {
                _videoPlayerController.play();
              },
              icon: const Icon(Icons.play_arrow),
            ),
          ],
        ),
      ],
    );
  }
}

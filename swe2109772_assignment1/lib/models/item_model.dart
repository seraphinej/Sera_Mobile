class Item {
  int? id;
  String name;
  String imgPath;
  String price;
  String description;
  bool isFavorited;
  bool isAddedToCart;
  int quantity;

  Item({
    this.id,
    required this.name,
    required this.imgPath,
    required this.price,
    required this.description,
    this.isFavorited = false,
    this.isAddedToCart = false,
    this.quantity = 1
  });

  static List<Item> getCoffeeItem() {
    return [
      Item(
        name: 'Iced Americano',
        imgPath: 'assets/images/Iced americano.png',
        price: 'RM6.50',
        description: 'A refreshing coffee drink made by diluting rich, espresso '
            'shots with cold water and served over ice. This beverage offers a '
            'bold and robust coffee flavor, perfect for those who prefer their '
            'coffee strong and invigorating.',
      ),
      Item(
        name: 'Iced Latte',
        imgPath: 'assets/images/latte.jpg',
        price: 'RM9.00',
        description: "A smooth and creamy coffee drink made with chilled espresso "
            "shots combined with cold milk and served over ice. It's a "
            "perfect blend of strong coffee and creamy milk, offering a delightful "
            "balance of flavors that's both refreshing and satisfying.",
      ),
      Item(
          name: 'Cappuccino',
          imgPath: 'assets/images/cappucino.jpg',
          price: 'RM8.00',
          description: 'A classic Italian coffee drink composed of equal parts espresso, steamed milk, '
              'and milk foam. It offers a rich and robust coffee flavor with a creamy texture '
              'and is often enjoyed with a sprinkle of cocoa or cinnamon on top.'
      ),
      Item(
          name: 'Caramel Macchiato',
          imgPath: 'assets/images/caramel macchiato.jpg',
          price: 'RM9.00',
          description: 'A sweet and creamy coffee drink made with freshly steamed milk, rich espresso, '
              'and a topping of velvety caramel sauce. Perfect for those who enjoy a '
              'balanced blend of espresso and sweetness.'
      )
    ];
  }

  static List<Item> getNonCoffeeItem() {
    return [
      Item(
        name: 'Green Tea Latte',
        imgPath: 'assets/images/greentea latte.jpg',
        price: 'RM9.00',
        description: 'A refreshing and creamy beverage that combines the earthy, '
            'slightly sweet flavors of matcha green tea with the smoothness of milk. '
            'The matcha used in the latte is finely ground green tea leaves, providing a natural energy boost along with antioxidants.',
      ),
      Item(
        name: 'Iced Chocolate',
        imgPath: 'assets/images/iced choco.jpg',
        price: 'RM9.00',
        description: "A rich and indulgent beverage made by blending high-quality "
            "chocolate syrup with cold milk and served over ice. It's a sweet and "
            "creamy treat that provides a refreshing way to enjoy the classic chocolate flavor.",
      ),
      Item(
        name: 'Lemonade',
        imgPath: 'assets/images/lemonade.jpg',
        price: 'RM7.00',
        description: "A refreshing and tangy beverage made from freshly squeezed lemons, water, and sugar. "
            "It's a perfect thirst-quencher on hot days and can be enjoyed plain "
            "or with added flavors like mint or berries."
      ),
      Item(
        name: 'Iced Milk Tea',
        imgPath: 'assets/images/milk tea.jpg',
        price: 'RM9.00',
        description: "A chilled, sweet beverage combining strong brewed tea with creamy milk, often sweetened "
            "with sugar or condensed milk. It's a popular choice for a cool and refreshing drink, "
            "especially in warmer weather."
      )
    ];
  }

  static List<Item> getJuiceItem() {
    return [
      Item(
        name: 'Watermelon Juice',
        imgPath: 'assets/images/watermelon juice.jpg',
        price: 'RM7.50',
        description: "A hydrating and refreshing drink made from blended ripe watermelon. "
            "It's naturally sweet, light, and packed with essential vitamins and minerals, "
            "making it a perfect thirst-quencher on a hot day.",
      ),
      Item(
        name: 'Orange Juice',
        imgPath: 'assets/images/orange juice.jpg',
        price: 'RM7.50',
        description: "Freshly squeezed Orange Juice is a vibrant and refreshing beverage "
            "made from ripe, juicy oranges. It offers a perfect balance of sweet and tangy flavors, "
            "packed with vitamin C and antioxidants, making it a healthy and invigorating choice.",
      ),
      Item(
          name: 'Carrot Juice',
          imgPath: 'assets/images/carrot juice.jpg',
          price: 'RM7.50',
          description: "A nutritious drink made from freshly juiced carrots, known for its vibrant "
              "color and slightly sweet flavor. It's rich in vitamins and antioxidants, making it a "
              "healthful choice for any time of day."
      ),
      Item(
          name: 'Apple Juice',
          imgPath: 'assets/images/apple juice.jpg',
          price: 'RM7.50',
          description: "A sweet and refreshing drink made from freshly pressed apples. It's packed "
              "with vitamins and offers a natural sweetness, making it a healthy and delicious beverage choice."
      )
    ];
  }

  static List<Item> getPastryItem() {
    return [
      Item(
        name: 'Tiramisu',
        imgPath: 'assets/images/tiramisu.jpg',
        price: 'RM10.50',
        description: "Tiramisu is a classic Italian dessert made with layers of coffee-soaked "
            "ladyfingers, creamy mascarpone cheese, and a dusting of cocoa powder. This "
            "elegant dessert offers a rich and luxurious combination of coffee and creamy "
            "flavors, perfect for any sweet tooth.",
      ),
      Item(
        name: 'Strawberry Cake',
        imgPath: 'assets/images/strawberry cake.jpg',
        price: 'RM10.50',
        description: "Strawberry Cake is a delightful dessert featuring moist, fluffy layers of cake "
            "infused with fresh strawberry flavor and topped with a creamy frosting. It's "
            "often adorned with fresh strawberries, offering a sweet and fruity treat "
            "that's perfect for any occasion.",
      ),
      Item(
          name: 'Cheese Cake',
          imgPath: 'assets/images/cheesecake.jpg',
          price: 'RM9.50',
          description: "A rich and creamy dessert featuring a smooth, velvety layer of sweetened cream "
              "cheese on a buttery graham cracker crust. It can be served plain or topped with "
              "fruits, chocolate, or caramel for added flavor."
      ),
      Item(
          name: 'Croissant',
          imgPath: 'assets/images/croissant.jpg',
          price: 'RM8.00',
          description: "A flaky, buttery French pastry with a golden brown exterior and a soft, airy "
              "interior. It's often enjoyed for breakfast or as a snack, plain or filled with ingredients "
              "like chocolate or almond paste."
      )
    ];
  }

  static List<Item> getPopularItems() {
    // Assuming the popular items are selected manually
    List<Item> coffeeItems = getCoffeeItem();
    List<Item> nonCoffeeItems = getNonCoffeeItem();
    List<Item> juiceItems = getJuiceItem();
    List<Item> pastryItems = getPastryItem();

    return [
      nonCoffeeItems[0], // Green Tea Latte
      coffeeItems[1],    // Iced Latte
      juiceItems[0],     // Watermelon Juice
      pastryItems[1],      // Strawberry Cake
      nonCoffeeItems[3], //Iced Milk Tea
      coffeeItems[3] //Caramel Macchiato
    ];
  }
}
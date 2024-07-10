class CategoryModel {
  String name;
  String iconPath;

  CategoryModel({
    required this.name,
    required this.iconPath
});

  static List<CategoryModel> getCategories(){
    List<CategoryModel> categories = [];

    categories.add(
      CategoryModel(
        name: 'Coffee',
        iconPath: 'assets/images/coffee.png',
      )
    );

    categories.add(
        CategoryModel(
          name: 'Non-coffee',
          iconPath: 'assets/images/bubble tea.png',
        )
    );

    categories.add(
        CategoryModel(
          name: 'Juice',
          iconPath: 'assets/images/juice.png',
        )
    );

    categories.add(
        CategoryModel(
          name: 'Pastry',
          iconPath: 'assets/images/cake.png',
        )
    );

    return categories;
  }
}
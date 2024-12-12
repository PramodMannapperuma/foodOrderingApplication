import 'package:flutter/material.dart';
import 'package:food_order/Screens/menuScreen/menu_items.dart';
import 'package:food_order/Screens/menuScreen/search_and_dropdown.dart';
import 'package:food_order/Screens/menuScreen/top_icons.dart';
import '../../models/category.dart';
import '../../models/menu.dart';
import '../../services/data_services.dart';
import 'category_list.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final DataService dataService = DataService();

  late Future<List<Category>> categoriesFuture;
  late Future<List<Menu>> menusFuture;

  String? selectedCategory;

  String? selectedMealType = 'Breakfast';

  int selectedIndex = -1;

  final Color selectedColor = Colors.green;
  final Color defaultColor = Colors.black;

  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    categoriesFuture = dataService.fetchCategories();
    menusFuture = dataService.fetchMenus();
    scrollController = ScrollController();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void onIconPressed(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  void onCategorySelected(String? categoryId) {
    setState(() {
      selectedCategory = categoryId;
    });
    debugPrint('CategoryId: $selectedCategory');

    // Scroll to the selected category
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToCategory(categoryId);
    });
  }

  void _scrollToCategory(String? categoryId) {
    if (categoryId == null) return;

    categoriesFuture.then((categories) {
      final index = categories
          .indexWhere((category) => category.menuCategoryId == categoryId);
      if (index >= 0) {
        scrollController.animateTo(
          index * 500.0, // Adjust based on the height of each category section
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MenuScreen'),
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder<List<Menu>>(
        future: menusFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text('Error loading menu'),
            );
          }

          final menu = snapshot.data ?? [];

          return CustomScrollView(
            controller: scrollController,
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.white,
                expandedHeight: 340,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    children: [
                      Column(
                        children: [
                          Image.network(
                            'https://picsum.photos/600/300',
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                DropDownAndSerch(
                                  selectedMealType: selectedMealType,
                                  onMealTypeChanged: (value) {
                                    setState(() {
                                      selectedMealType = value;
                                    });
                                  },
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                CategoryList(
                                  categoriesFuture: categoriesFuture,
                                  onCategorySelected: onCategorySelected,
                                  selectedCategoryId: selectedCategory,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      TopIcons(
                          selectedIndex: selectedIndex,
                          selectedColor: selectedColor,
                          defaultColor: defaultColor,
                          onIconPressed: onIconPressed)
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: MenuItems(
                  menus: menu,
                  selectedCategory: selectedCategory,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

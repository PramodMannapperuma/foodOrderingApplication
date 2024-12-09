// import 'package:flutter/material.dart';
// import '../models/category.dart';
// import '../models/menu.dart';
// import '../services/data_services.dart';
// import '../widgets/category_list.dart';
// import '../widgets/meal_and_search_widget.dart';
// import '../widgets/menu_item_list_widget.dart';
// import '../widgets/top_icon_widget.dart';
// import 'category_screen.dart';
//
//
// class MenuScreen extends StatefulWidget {
//   @override
//   State<MenuScreen> createState() => _MenuScreenState();
// }
//
// class _MenuScreenState extends State<MenuScreen> {
//   final DataService dataService = DataService();
//   late Future<List<Category>> categoriesFuture;
//   String? selectedCategory;
//   String? selectedMealType = 'Breakfast';
//   int selectedIndex = -1;
//   final Color selectedColor = Colors.green;
//   final Color defaultColor = Colors.black;
//   late ScrollController scrollController; // Add ScrollController
//
//   @override
//   void initState() {
//     super.initState();
//     categoriesFuture = dataService.fetchCategories();
//     scrollController = ScrollController(); // Initialize ScrollController
//   }
//   @override
//   void dispose() {
//     scrollController.dispose(); // Dispose of ScrollController
//     super.dispose();
//   }
//
//   void onIconPressed(int index) {
//     setState(() {
//       selectedIndex = index;
//     });
//   }
//
//   void onCategorySelected(String? categoryId) {
//     setState(() {
//       selectedCategory = categoryId;
//     });
//     debugPrint('CategoryId: $selectedCategory');
//     // Navigator.push(
//     //   context,
//     //   MaterialPageRoute(
//     //     builder: (context) => CategoryScreen(menuID: categoryId),
//     //   ),
//     // );
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Menu Items'),
//       ),
//       body: FutureBuilder<List<Menu>>(
//         future: dataService.fetchMenus(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }
//           if (snapshot.hasError) {
//             return Center(child: Text("Error loading menus"));
//           }
//
//           final menus = snapshot.data!;
//           return CustomScrollView(
//             slivers: [
//               SliverAppBar(
//                 expandedHeight: 200,
//                 floating: false,
//                 pinned: true,
//                 flexibleSpace: FlexibleSpaceBar(
//                   background: Stack(
//                     children: [
//                       Image.network(
//                         'https://picsum.photos/600/300',
//                         fit: BoxFit.cover,
//                         width: double.infinity,
//                       ),
//                       TopIconsWidget(
//                         selectedIndex: selectedIndex,
//                         selectedColor: selectedColor,
//                         defaultColor: defaultColor,
//                         onIconPressed: onIconPressed,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               SliverToBoxAdapter(
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       MealDropdownAndSearchWidget(
//                         selectedMealType: selectedMealType,
//                         onMealTypeChanged: (value) {
//                           setState(() {
//                             selectedMealType = value;
//                           });
//                         },
//                       ),
//                       CategoryListWidget(
//                         categoriesFuture: categoriesFuture,
//                         onCategorySelected: onCategorySelected,
//                         selectedCategoryId: selectedCategory,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               MenuItemsListWidget(
//                 menus: menus,
//                 selectedCategory: selectedCategory,
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import '../models/category.dart';
import '../models/menu.dart';
import '../services/data_services.dart';
import '../widgets/category_list.dart';
import '../widgets/meal_and_search_widget.dart';
import '../widgets/menu_item_list_widget.dart';
import '../widgets/top_icon_widget.dart';

class MenuScreen extends StatefulWidget {
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
      final index = categories.indexWhere((category) => category.menuCategoryId == categoryId);
      if (index >= 0) {
        scrollController.animateTo(
          index * 650.0, // Adjust based on the height of each category section
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
        title: const Text('Menu Items'),
      ),
      body: FutureBuilder<List<Menu>>(
        future: menusFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text("Error loading menus"));
          }

          final menus = snapshot.data!;
          return CustomScrollView(
            controller: scrollController,
            slivers: [
              SliverAppBar(
                expandedHeight: 200,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    children: [
                      Image.network(
                        'https://picsum.photos/600/300',
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                      TopIconsWidget(
                        selectedIndex: selectedIndex,
                        selectedColor: selectedColor,
                        defaultColor: defaultColor,
                        onIconPressed: onIconPressed,
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MealDropdownAndSearchWidget(
                        selectedMealType: selectedMealType,
                        onMealTypeChanged: (value) {
                          setState(() {
                            selectedMealType = value;
                          });
                        },
                      ),
                      CategoryListWidget(
                        categoriesFuture: categoriesFuture,
                        onCategorySelected: onCategorySelected,
                        selectedCategoryId: selectedCategory,
                      ),
                    ],
                  ),
                ),
              ),
              FutureBuilder<List<Category>>(
                future: categoriesFuture,
                builder: (context, categorySnapshot) {
                  if (categorySnapshot.connectionState == ConnectionState.waiting) {
                    return const SliverToBoxAdapter(
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  if (categorySnapshot.hasError) {
                    return const SliverToBoxAdapter(
                      child: Center(child: Text("Error loading categories")),
                    );
                  }

                  final categories = categorySnapshot.data!;
                  return MenuItemsListWidget(
                    menus: menus,
                    selectedCategory: selectedCategory,
                    // categories: categories,
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

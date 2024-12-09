import 'package:flutter/material.dart';
import 'package:food_ordering_app/screens/menu_item_screen.dart';
import '../models/menu.dart';
import '../models/category.dart';
import '../services/data_services.dart';

class MenuItemsListWidget extends StatelessWidget {
  final List<Menu> menus;
  final String? selectedCategory;

  MenuItemsListWidget({
    required this.menus,
    required this.selectedCategory,
  });

  @override
  Widget build(BuildContext context) {
    final DataService dataService = DataService();

    return FutureBuilder<List<Category>>(
      future: dataService.fetchCategories(), // Fetch categories here
      builder: (context, categorySnapshot) {
        if (categorySnapshot.connectionState == ConnectionState.waiting) {
          return SliverToBoxAdapter(child: Center(child: CircularProgressIndicator()));
        }

        if (categorySnapshot.hasError) {
          return SliverToBoxAdapter(child: Center(child: Text("Error loading categories")));
        }

        final categories = categorySnapshot.data ?? [];

        return SliverList(
          delegate: SliverChildBuilderDelegate(
                (context, index) {
              final menu = menus[index];
              debugPrint("Menu item id: ${menu.menuEntities}"); // Prints all menu entities
              return Card(
                elevation: 5,
                margin: EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Display all items inside the menu (MenuEntities from all categories)
                    ...categories.where((category) {
                      // Show categories that the menu belongs to
                      return menu.menuCategoryIds.contains(category.menuCategoryId);
                    }).map((category) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Category Title
                          Padding(
                            padding: const EdgeInsets.only(left: 15, top: 8.0),
                            child: Text(
                              category.title['en'] ?? 'Category',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          // Display menu entities (items) in this category
                          ...category.menuEntities.map((entity) {
                            return ListTile(
                              contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                              title: Text(
                                entity.id.split('-').last.trim(), // Display entity type as a label
                                style: TextStyle(fontSize: 16),
                              ),
                              onTap: () {
                                // Send selected entity's ID to the MenuItemPage
                                debugPrint("Selected Menu Entity ID: ${entity.id}"); // Prints selected entity's ID
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MenuItemPage(menuItemId: entity.id), // Passing the selected entity's ID
                                  ),
                                );
                              },
                            );
                          }).toList(),
                        ],
                      );
                    }).toList(),
                  ],
                ),
              );
            },
            childCount: menus.length,
          ),
        );
      },
    );
  }
}

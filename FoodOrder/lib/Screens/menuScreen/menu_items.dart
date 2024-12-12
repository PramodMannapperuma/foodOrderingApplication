import 'package:flutter/material.dart';
import 'package:food_order/Screens/menuScreen/item_details.dart';
import 'package:food_order/models/category.dart';

import '../../models/menu.dart';
import '../../services/data_services.dart';

class MenuItems extends StatelessWidget {
  final List<Menu> menus;
  final String? selectedCategory;

  const MenuItems({super.key, required this.menus, this.selectedCategory});

  @override
  Widget build(BuildContext context) {
    final DataService dataService = DataService();

    return FutureBuilder<List<Category>>(
      future: dataService.fetchCategories(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text("Error loading categories"));
        }

        final categories = snapshot.data ?? [];

        return Column(
          children: menus.map((menu) {
            return Card(
              color: Colors.white,
              elevation: 1,
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...categories.where((category) {
                    return menu.menuCategoryIds
                        .contains(category.menuCategoryId);
                  }).map((category) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15, top: 2.0),
                          child: Text(
                            category.title['en'] ?? 'Category',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        ...category.menuEntities.map((entity) {
                          return FutureBuilder(
                              future: dataService.fetchMenuItems(entity.id),
                              builder: (context, itemSnapshot) {
                                if(itemSnapshot.connectionState == ConnectionState.waiting) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                if (itemSnapshot.hasError) {
                                  return const Center(
                                    child: Text("Error loading items"),
                                  );
                                }
                                final items = itemSnapshot.data ?? [];
                                return Column(
                                    children: items.map((item) {
                                  return ListTile(
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 5),
                                    leading: ClipRRect(
                                      borderRadius: BorderRadius.circular(12.0),
                                      child: Image.network(
                                        item.imageURL.isEmpty ? item.imageURL : 'https://picsum.photos/600/300',
                                        fit: BoxFit.cover,
                                        width: 50,
                                        height: 50,
                                      ),
                                    ),
                                    title: Text(
                                      item.title['en'] ?? 'Item Title',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.description['en'] ?? 'No description',
                                        ),
                                        SizedBox(height: 6,),
                                        Text(
                                          '\$${(item.priceInfo.price.deliveryPrice / 100).toStringAsFixed(2)}',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green,
                                          ),
                                        ),
                                      ],
                                    ),
                                    onTap: () {
                                      debugPrint("Selected Item ID: ${item.id}");
                                      Navigator.push(context,
                                      MaterialPageRoute(builder: (context) => ItemDetails(menuItemId: item.menuItemID,),),);
                                    },
                                  );
                                }).toList(),
                                );

                              });

                          // return ListTile(
                          //   contentPadding:
                          //       const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                          //   leading: ClipRRect(
                          //     borderRadius: BorderRadius.circular(12.0),
                          //     child: Image.network(
                          //       'https://picsum.photos/600/300',
                          //       fit: BoxFit.cover,
                          //       width: 50,
                          //       height: 50,
                          //     ),
                          //   ),
                          //   title: Text(
                          //     entity.id.split('-').last.trim(),
                          //     style: const TextStyle(fontSize: 16),
                          //   ),
                          //   subtitle: Text('description'),
                          //   onTap: () {
                          //     debugPrint(
                          //         "Selected Menu Entity ID: ${entity.id}");
                          //   },
                          // );
                        }).toList(),
                      ],
                    );
                  }).toList(),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

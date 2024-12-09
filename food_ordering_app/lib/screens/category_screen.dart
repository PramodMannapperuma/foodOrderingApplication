import 'package:flutter/material.dart';
import '../models/category.dart';  // Assuming Category and MenuEntity models are defined
import '../services/data_services.dart';  // Assuming DataService is defined for fetching data
import 'menu_item_screen.dart';  // Assuming MenuItemScreen is another screen that displays menu items

class CategoryScreen extends StatelessWidget {
  final String menuID;
  final DataService dataService = DataService();

  // Constructor to receive menuID for filtering categories
  CategoryScreen({required this.menuID});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Categories")),
      body: FutureBuilder<List<Category>>(
        // Fetch categories based on the menuID
        future: dataService.fetchCategories(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error loading categories"));
          }

          final categories = snapshot.data!;

          // Display list of categories
          return ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];

              // Displaying category details
              return Card(
                margin: EdgeInsets.all(10),
                elevation: 4,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category title
                      Text(
                        category.title['en'] ?? 'No Title',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 6),
                      // Category subtitle (if exists)
                      Text(
                        category.subTitle['en'] ?? 'No Subtitle',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 10),
                      // Menu entities within the category
                      for (var entity in category.menuEntities)
                        ListTile(
                          title: Text(entity.id.split('-').last), // Display the menu entity ID
                          subtitle: Text(entity.type), // Display the entity type (e.g., ITEM)
                          onTap: () {
                            // Navigate to MenuItemScreen for the selected menu entity
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MenuItemPage(menuItemId: '')
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

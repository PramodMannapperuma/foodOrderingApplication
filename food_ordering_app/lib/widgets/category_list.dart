import 'package:flutter/material.dart';
import '../models/category.dart';

class CategoryListWidget extends StatelessWidget {
  final Future<List<Category>> categoriesFuture;
  final Function(String?) onCategorySelected;
  final String? selectedCategoryId; // Add this to track the selected category

  CategoryListWidget({
    required this.categoriesFuture,
    required this.onCategorySelected,
    this.selectedCategoryId, // Accept the selected category ID
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Category>>(
      future: categoriesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text("Error loading categories"));
        }

        final categories = snapshot.data ?? [];
        return SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];

              // Check if the category is selected
              final isSelected = selectedCategoryId == category.menuCategoryId;
              debugPrint("Selcted category: $selectedCategoryId");

              return Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: GestureDetector(
                  onTap: () {
                    // If the category is already selected, deselect it
                    if (isSelected) {
                      onCategorySelected(null); // Deselect by passing null
                    } else {
                      onCategorySelected(category.menuCategoryId); // Select the category
                    }
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(90), // Make the Chip rounder
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 2), // Adjust padding to center content
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey,width: 1),
                        color: isSelected ? Colors.green : Colors.white,
                        borderRadius: BorderRadius.circular(90), // Rounded corners
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center, // Center the content horizontally
                        crossAxisAlignment: CrossAxisAlignment.center, // Center the content vertically
                        children: [
                          Text(
                            category.title['en'] ?? "Category",
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                              fontSize: 16, // Adjust font size for a more centered appearance
                            ),
                          ),
                          if (isSelected) // Add the close icon only if selected
                            IconButton(
                              icon: Icon(Icons.close, size: 18),
                              onPressed: () {
                                onCategorySelected(null); // Deselect the category
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
import 'package:flutter/material.dart';

import '../../models/menu_item.dart';
import '../../services/data_services.dart';

class ItemDetails extends StatefulWidget {
  final String menuItemId;
  const ItemDetails({super.key, required this.menuItemId});

  @override
  State<ItemDetails> createState() => _ItemDetailsState();
}

class _ItemDetailsState extends State<ItemDetails> {
  int itemCount = 0; // To manage quantity increment and decrement
  String? selectedSize; // To store the selected size
  List<String> selectedToppings = []; // List of selected toppings
  TextEditingController commentController = TextEditingController(); // To manage comment text

  String calculatePer100g(String nutrient,int netQuantityUpper, int netQuantityLower) {
    if(nutrient == null || netQuantityUpper == null || netQuantityLower == null) {
      return "N/";
    }
    num lower = netQuantityLower ?? 0.0;
    num upper = netQuantityUpper ?? 0.0;
    double average = (lower + upper) / 2;

    if (netQuantityUpper > 0) {
      return (average / netQuantityUpper * 100).toStringAsFixed(2);
    }
    return "N/A";
  }

  @override
  Widget build(BuildContext context) {
    final DataService dataService = DataService();
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu Item Details'),
      ),
      body: FutureBuilder<List<Item>>(
        future: dataService.fetchMenuItems(widget.menuItemId), // Fetch items by menuItemId
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (snapshot.hasData) {
            final items = snapshot.data!;
            final menuItem = items.firstWhere(
                  (item) => item.menuItemID == widget.menuItemId,
              orElse: () => throw Exception("Menu item not found"),
            );

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Display Image
                  Image.network(
                    menuItem.imageURL.isNotEmpty ? menuItem.imageURL : 'https://via.placeholder.com/200',
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),

                  // Title and Price
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      menuItem.title['en'] ?? 'No Title',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Price: \$${(menuItem.priceInfo.price.deliveryPrice / 100).toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 16, color: Colors.green),
                    ),
                  ),

                  // Description
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      menuItem.description['en'] ?? 'No description available',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),

                  // Tab for Ingredients, Nutrients, Instructions, and Allergies
                  DefaultTabController(
                    length: 4,
                    child: Column(
                      children: [
                        TabBar(
                          tabs: [
                            Tab(text: 'Ingredients'),
                            Tab(text: 'Nutrients'),
                            Tab(text: 'Instructions'),
                            Tab(text: 'Allergies'),
                          ],
                        ),
                        Container(
                          height: 200, // Height for the tab content
                          child: TabBarView(
                            children: [
                              // Ingredients Tab
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    const SizedBox(height: 8),
                                    Text(
                                      'Nutrients per 100g:',
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    Text('Calories: ${calculatePer100g('Calories', menuItem.nutrientData.calories.energyInterval.upper , menuItem.nutrientData.calories.energyInterval.lower)} kcal'),
                                    // Text('Proteins: ${calculatePer100g('Protein', menuItem.nutrientData.proteins.energyInterval.upper as double, menuItem.nutrientData.proteins.energyInterval.lower as double)} g'),
                                    Text('Fats: ${calculatePer100g('Kilojules', menuItem.nutrientData.kilojules.energyInterval.upper, menuItem.nutrientData.kilojules.energyInterval.lower)} g'),
                                    // Text('Carbohydrates: ${calculatePer100g('Carbohydrates', menuItem.nutrientData.carbohydrates.energyInterval.upper as double, menuItem.nutrientData.carbohydrates.energyInterval.lower as double)} g'),
                                  ],
                                ),
                              ),
                              // Nutrients Tab
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(menuItem.nutrientData.calories.energyInterval.upper .toString()),
                              ),
                              // Instructions Tab
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(menuItem.nutrientData.toString()),
                              ),
                              // Allergies Tab
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(menuItem.nutrientData.toString()),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Toppings Selection
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Available Toppings:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        // ...menuItem.nutrientData.map((topping) {
                        //   return CheckboxListTile(
                        //     title: Text(topping),
                        //     value: selectedToppings.contains(topping),
                        //     onChanged: (bool? value) {
                        //       setState(() {
                        //         if (value == true) {
                        //           selectedToppings.add(topping);
                        //         } else {
                        //           selectedToppings.remove(topping);
                        //         }
                        //       });
                        //     },
                        //   );
                        // }).toList(),
                      ],
                    ),
                  ),

                  // Size Selection
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Select Size:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        // DropdownButton<String>(
                        //   value: selectedSize,
                        //   hint: Text('Choose Size'),
                        //   onChanged: (String? newSize) {
                        //     setState(() {
                        //       selectedSize = newSize;
                        //     });
                        //   },
                        // items: menuItem.sizes.map<DropdownMenuItem<String>>((String size) {
                        //   return DropdownMenuItem<String>(
                        //     value: size,
                        //     child: Text(size),
                        //   );
                        // }).toList(),
                        // ),
                      ],
                    ),
                  ),

                  // Comment Text Field
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      controller: commentController,
                      decoration: InputDecoration(
                        labelText: 'Add Comments',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                  ),

                  // Quantity and Add to Cart Buttons
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        // Decrease and Increase Buttons
                        IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: itemCount > 0
                              ? () {
                            setState(() {
                              itemCount--;
                            });
                          }
                              : null,
                        ),
                        Text('$itemCount', style: TextStyle(fontSize: 20)),
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            setState(() {
                              itemCount++;
                            });
                          },
                        ),

                        // Add to Cart Button
                        Spacer(),
                        ElevatedButton(
                          onPressed: () {
                            // Add to cart functionality here
                          },
                          child: Text('Add to Cart'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Center(child: Text('No data available.'));
          }
        },
      ),
    );
  }
}
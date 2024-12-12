import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import '../models/menu.dart';
import '../models/category.dart';
import '../models/menu_item.dart';
import '../models/modifier.dart';

class DataService {
  Future<Map<String, dynamic>> loadJsonData() async {
    try {
      String jsonString = await rootBundle.loadString(
          'assets/assignment-dataset.json');
      Map<String, dynamic> jsonData = json.decode(jsonString);
      // debugPrint("JSON Loaded: $jsonData");
      return jsonData;
    } catch (e) {
      debugPrint("Error loading JSON: $e");
      throw Exception("Error loading JSON data");
    }
  }

  Future<List<Menu>> fetchMenus() async {
    try {
      final data = await loadJsonData();
      final menusData = data['Result']['Menu']; // Access Menu under Result
      if (menusData == null) {
        // debugPrint("JSON Loaded: $menusData");
        throw Exception("Menu data is missing or null");
      }
      debugPrint("JSON Loaded: $menusData");

      return menusData.map<Menu>((menu) => Menu.fromJson(menu)).toList();
    } catch (e) {
      print("Error fetching menus: $e");
      throw Exception("Error fetching menus");
    }
  }

  Future<List<Category>> fetchCategories() async {
    try {
      final data = await loadJsonData();
      final categoriesData =
          data['Result']['Categories']; // Navigate to Categories
      // debugPrint("Categories fetched : $categoriesData");
      return categoriesData
          .map<Category>((category) => Category.fromJson(category))
          .toList();
    } catch (e) {
      debugPrint("Error fetching categories: $e");
      throw Exception("Error fetching categories");
    }
  }

  Future<List<Modifier>> fetchModifiers(String menuItemID) async {
    try {
      final data = await loadJsonData();
      final itemsData = data['Result']['MenuItems'];
      final selectedItem =
          itemsData.firstWhere((item) => item['ID'] == menuItemID);
      final modifierGroupRules = selectedItem['ModifierGroupRules'] ?? [];

      final modifiersData = data['Result']['Modifiers'];
      return modifiersData
          .where(
              (modifier) => modifierGroupRules.contains(modifier['ModifierID']))
          .map<Modifier>((modifier) => Modifier.fromJson(modifier))
          .toList();
    } catch (e) {
      debugPrint("Error fetching modifiers: $e");
      throw Exception("Error fetching modifiers");
    }
  }

  Future<List<Item>> fetchMenuItems(String categoryID) async {
    try {
      final data = await loadJsonData();
      final itemsData = data['Result']['Items'];

      if (itemsData == null) {
        debugPrint("Items data is null");
        return []; // Return an empty list if Items is null
      }

      // Filter items by categoryID
      final filteredItems = itemsData
          .where((item) {
        // MenuItemID is a string, not a list, so we directly compare it
        var menuItemId = item['MenuItemID']; // Get the MenuItemID (which is a string)

        if (menuItemId == null) {
          return false; // If MenuItemID is null, don't include it
        }

        // Check if the menuItemId matches the categoryID
        return menuItemId == categoryID;
      })
          .map<Item>((item) => Item.fromJson(item)) // Convert JSON to Item model
          .toList();

      return filteredItems; // Return the filtered list of items
    } catch (e) {
      debugPrint("Error fetching menu items: $e");
      throw Exception("Error fetching menu items");
    }
  }


}

import 'package:flutter/material.dart';
import '../models/modifier.dart';
import '../services/data_services.dart';

class ModifierScreen extends StatelessWidget {
  final String menuItemID;
  final DataService dataService = DataService();

  ModifierScreen({required this.menuItemID});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Modifiers")),
      body: FutureBuilder<List<Modifier>>(
        future: dataService.fetchModifiers(menuItemID),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error loading modifiers"));
          }

          final modifiers = snapshot.data!;
          return ListView.builder(
            itemCount: modifiers.length,
            itemBuilder: (context, index) {
              final modifier = modifiers[index];
              return ListTile(
                title: Text(modifier.name),
                subtitle: Text("\$${modifier.price.toStringAsFixed(2)}"),
                trailing: Checkbox(
                  value: false,
                  onChanged: (value) {
                    // Add logic to handle modifier selection
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

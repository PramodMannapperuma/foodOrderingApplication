import 'package:flutter/material.dart';

class MealDropdownAndSearchWidget extends StatelessWidget {
  final String? selectedMealType;
  final Function(String?) onMealTypeChanged;

  MealDropdownAndSearchWidget({
    required this.selectedMealType,
    required this.onMealTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        DropdownButton<String>(
          value: selectedMealType,
          hint: Text('Select Meal'),
          onChanged: onMealTypeChanged,
          items: <String>['Breakfast', 'Lunch']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            // Add your search functionality here
          },
        ),
      ],
    );
  }
}

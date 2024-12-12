class Modifier {
  final String modifierID;
  final String name;
  final double price;

  Modifier({
    required this.modifierID,
    required this.name,
    required this.price,
  });

  factory Modifier.fromJson(Map<String, dynamic> json) {
    return Modifier(
      modifierID: json['ModifierID'] ?? '',
      name: json['Name'] ?? '',
      price: (json['Price'] ?? 0).toDouble(),
    );
  }
}

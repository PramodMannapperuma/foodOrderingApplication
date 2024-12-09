class PriceInfo {
  final Price price;

  PriceInfo({required this.price});

  factory PriceInfo.fromJson(Map<String, dynamic> json) {
    return PriceInfo(
      price: Price.fromJson(json['Price']),
    );
  }
}

class Price {
  final int deliveryPrice;
  final int pickupPrice;
  final int tablePrice;

  Price({
    required this.deliveryPrice,
    required this.pickupPrice,
    required this.tablePrice,
  });

  factory Price.fromJson(Map<String, dynamic> json) {
    return Price(
      deliveryPrice: json['DeliveryPrice'],
      pickupPrice: json['PickupPrice'],
      tablePrice: json['TablePrice'],
    );
  }
}

class QuantityInfo {
  final Quantity quantity;

  QuantityInfo({required this.quantity});

  factory QuantityInfo.fromJson(Map<String, dynamic> json) {
    return QuantityInfo(
      quantity: Quantity.fromJson(json['Quantity']),
    );
  }
}

class Quantity {
  final int minPermitted;
  final int maxPermitted;
  final bool isMinPermittedOptional;

  Quantity({
    required this.minPermitted,
    required this.maxPermitted,
    required this.isMinPermittedOptional,
  });

  factory Quantity.fromJson(Map<String, dynamic> json) {
    return Quantity(
      minPermitted: json['MinPermitted'],
      maxPermitted: json['MaxPermitted'],
      isMinPermittedOptional: json['IsMinPermittedOptional'],
    );
  }
}

class NutrientData {
  final Calories calories;
  final Kilojules kilojules;

  NutrientData({required this.calories, required this.kilojules});

  factory NutrientData.fromJson(Map<String, dynamic> json) {
    return NutrientData(
      calories: Calories.fromJson(json['Calories']),
      kilojules: Kilojules.fromJson(json['Kilojules']),
    );
  }
}

class Calories {
  final EnergyInterval energyInterval;
  final int displayType;

  Calories({required this.energyInterval, required this.displayType});

  factory Calories.fromJson(Map<String, dynamic> json) {
    return Calories(
      energyInterval: EnergyInterval.fromJson(json['EnergyInterval']),
      displayType: json['DisplayType'],
    );
  }
}

class Kilojules {
  final EnergyInterval energyInterval;
  final int displayType;

  Kilojules({required this.energyInterval, required this.displayType});

  factory Kilojules.fromJson(Map<String, dynamic> json) {
    return Kilojules(
      energyInterval: EnergyInterval.fromJson(json['EnergyInterval']),
      displayType: json['DisplayType'],
    );
  }
}

class EnergyInterval {
  final int lower;
  final int upper;

  EnergyInterval({required this.lower, required this.upper});

  factory EnergyInterval.fromJson(Map<String, dynamic> json) {
    return EnergyInterval(
      lower: json['Lower'],
      upper: json['Upper'],
    );
  }
}

class Item {
  final String id;
  final String menuItemID;
  final String storeID;
  final Map<String, String> title;
  final Map<String, String> description;
  final String imageURL;
  final PriceInfo priceInfo;
  final QuantityInfo quantityInfo;
  final NutrientData nutrientData;
  final String externalData;
  final String createdDate;
  final String modifiedDate;

  Item({
    required this.id,
    required this.menuItemID,
    required this.storeID,
    required this.title,
    required this.description,
    required this.imageURL,
    required this.priceInfo,
    required this.quantityInfo,
    required this.nutrientData,
    required this.externalData,
    required this.createdDate,
    required this.modifiedDate,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['ID'],
      menuItemID: json['MenuItemID'],
      storeID: json['StoreID'],
      title: Map<String, String>.from(json['Title']),
      description: Map<String, String>.from(json['Description']),
      imageURL: json['ImageURL'],
      priceInfo: PriceInfo.fromJson(json['PriceInfo']),
      quantityInfo: QuantityInfo.fromJson(json['QuantityInfo']),
      nutrientData: NutrientData.fromJson(json['NutrientData']),
      externalData: json['ExternalData'],
      createdDate: json['CreatedDate'],
      modifiedDate: json['ModifiedDate'],
    );
  }
}

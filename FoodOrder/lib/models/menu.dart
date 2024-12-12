class MenuAvailability {
  final String startTime;
  final String endTime;

  MenuAvailability({required this.startTime, required this.endTime});

  factory MenuAvailability.fromJson(Map<String, dynamic> json) {
    return MenuAvailability(
      startTime: json['StartTime'],
      endTime: json['EndTime'],
    );
  }
}

class MenuEntity {
  final String id;
  final String type;

  MenuEntity({required this.id, required this.type});

  factory MenuEntity.fromJson(Map<String, dynamic> json) {
    return MenuEntity(
      id: json['ID'],
      type: json['Type'],
    );
  }
}

class Menu {
  final String id;
  final String menuId;
  final String verticalId;
  final String storeId;
  final Map<String, String> title;
  final String? subTitle;
  final String? description;
  final Map<String, MenuAvailability> menuAvailability;
  final List<String> menuCategoryIds;
  final List<MenuEntity> menuEntities; // Added field
  final String createdDate;
  final String modifiedDate;
  final String createdBy;
  final String modifiedBy;

  Menu({
    required this.id,
    required this.menuId,
    required this.verticalId,
    required this.storeId,
    required this.title,
    this.subTitle,
    this.description,
    required this.menuAvailability,
    required this.menuCategoryIds,
    required this.menuEntities, // Added field
    required this.createdDate,
    required this.modifiedDate,
    required this.createdBy,
    required this.modifiedBy,
  });

  factory Menu.fromJson(Map<String, dynamic> json) {
    var availability = <String, MenuAvailability>{};
    (json['MenuAvailability'] as Map<String, dynamic>).forEach((key, value) {
      availability[key] = MenuAvailability.fromJson(value);
    });

    var entities = <MenuEntity>[];
    if (json['MenuEntities'] != null) {
      entities = (json['MenuEntities'] as List<dynamic>)
          .map((e) => MenuEntity.fromJson(e))
          .toList();
    }

    return Menu(
      id: json['ID'],
      menuId: json['MenuID'],
      verticalId: json['VerticalID'],
      storeId: json['StoreID'],
      title: Map<String, String>.from(json['Title']),
      subTitle: json['SubTitle'],
      description: json['Description'],
      menuAvailability: availability,
      menuCategoryIds: List<String>.from(json['MenuCategoryIDs']),
      menuEntities: entities, // Populate menu entities
      createdDate: json['CreatedDate'],
      modifiedDate: json['ModifiedDate'],
      createdBy: json['CreatedBy'],
      modifiedBy: json['ModifiedBy'],
    );
  }
}

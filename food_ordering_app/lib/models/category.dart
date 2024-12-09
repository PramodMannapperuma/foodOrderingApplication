class MenuEntity {
  final String id;
  final String type;

  MenuEntity({
    required this.id,
    required this.type,
  });

  factory MenuEntity.fromJson(Map<String, dynamic> json) {
    return MenuEntity(
      id: json['ID'],
      type: json['Type'],
    );
  }
}

class Category {
  final String id;
  final String menuCategoryId;
  final String menuId;
  final String storeId;
  final Map<String, String> title;
  final Map<String, String> subTitle;
  final List<MenuEntity> menuEntities;
  final String createdDate;
  final String modifiedDate;
  final String createdBy;
  final String modifiedBy;

  Category({
    required this.id,
    required this.menuCategoryId,
    required this.menuId,
    required this.storeId,
    required this.title,
    required this.subTitle,
    required this.menuEntities,
    required this.createdDate,
    required this.modifiedDate,
    required this.createdBy,
    required this.modifiedBy,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    var entities = <MenuEntity>[];
    if (json['MenuEntities'] != null) {
      entities = (json['MenuEntities'] as List)
          .map((e) => MenuEntity.fromJson(e))
          .toList();
    }

    return Category(
      id: json['ID'],
      menuCategoryId: json['MenuCategoryID'],
      menuId: json['MenuID'],
      storeId: json['StoreID'],
      title: Map<String, String>.from(json['Title']),
      subTitle: Map<String, String>.from(json['SubTitle']),
      menuEntities: entities,
      createdDate: json['CreatedDate'],
      modifiedDate: json['ModifiedDate'],
      createdBy: json['CreatedBy'],
      modifiedBy: json['ModifiedBy'],
    );
  }
}

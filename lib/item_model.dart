class InventoryItem {
  final int? id;
  final String name;
  // final String description;
  final String category;
  final String image;
  final int givenAway;

  InventoryItem({
    this.id,
    required this.name,
    // required this.description,
    required this.category,
    required this.image,
    required this.givenAway,
  });

  factory InventoryItem.fromJson(Map<String, dynamic> json) {
    return InventoryItem(
      id: json['id'] as int?,
      name: json['name'] as String,
      // description: json['description'] as String,
      category: json['category'] as String,
      image: json['image'] as String,
      givenAway: json['givenAway'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      // 'description': description,
      'category': category,
      'image': image,
      'givenAway': givenAway,
    };
  }
}

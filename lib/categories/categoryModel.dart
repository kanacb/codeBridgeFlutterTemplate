
class Category {
  final String id;
  final String name;
  final String description;
  final String image;
  final String createdBy;
  final String createdAt;
  final String updatedAt;

  Category(
      {required this.id,
      required this.name,
      required this.description,
      required this.image,
      required this.createdBy,
      required this.createdAt,
      required this.updatedAt});

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
        id: map['_id'] as String,
        name: map['name'] as String,
        description: map['description'] as String,
        image: map['image'],
        createdBy: map['createdBy'] as String,
        createdAt: map['createdAt'] as String,
        updatedAt: map['updatedAt'] as String);
  }

  @override
  String toString() => 'Category(name: $name, description : $description)';
}
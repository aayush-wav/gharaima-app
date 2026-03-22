class CategoryModel {
  final int id;
  final String name;
  final String? iconUrl;
  final String? description;

  CategoryModel({
    required this.id,
    required this.name,
    this.iconUrl,
    this.description,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'],
      iconUrl: json['icon_url'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon_url': iconUrl,
      'description': description,
    };
  }
}

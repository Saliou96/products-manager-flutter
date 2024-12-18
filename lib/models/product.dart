class Product {
  String id;
  String name;
  String description;
  double price;

  Product({
    this.id = '',
    required this.name,
    required this.description,
    required this.price,
  });

  // Convertit l'objet en Map pour Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'price': price,
    };
  }

  // Crée un objet Product depuis un DocumentSnapshot
  factory Product.fromMap(Map<String, dynamic> map, String documentId) {
    return Product(
      id: documentId,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
    );
  }
}

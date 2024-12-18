import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../models/product.dart';

class ProductController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final RxList<Product> products = <Product>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  // Récupérer tous les produits
  void fetchProducts() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('products').get();
      products.value = querySnapshot.docs
          .map((doc) =>
              Product.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      Get.snackbar("Erreur", "Impossible de récupérer les produits : $e");
    }
  }

  // Ajouter un produit
  Future<void> addProduct(Product product) async {
    try {
      await _firestore.collection('products').add(product.toMap());
      Get.snackbar("Succès", "Produit ajouté avec succès");
      Get.back();
      fetchProducts(); // Rafraîchit la liste
    } catch (e) {
      Get.snackbar("Erreur", "Impossible d'ajouter le produit : $e");
    }
  }

  // Mettre à jour un produit
  Future<void> updateProduct(Product product) async {
    await _firestore
        .collection('products')
        .doc(product.id)
        .update(product.toMap());
    fetchProducts();
  }

  // Supprimer un produit
  Future<void> deleteProduct(String productId) async {
    await _firestore.collection('products').doc(productId).delete();
    fetchProducts();
  }
}

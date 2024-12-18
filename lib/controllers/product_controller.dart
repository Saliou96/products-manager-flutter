import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
      Get.snackbar(
        "Erreur",
        "Impossible de récupérer les produits : $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    }
  }

  // Ajouter un produit
  void addProduct(Product product) async {
    try {
      await _firestore.collection('products').add(product.toMap());
      Get.back();
      Get.snackbar(
        "Succès",
        "Produit ajouté avec succès",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      fetchProducts(); // Rafraîchit la liste
    } catch (e) {
      Get.snackbar("Erreur", "Impossible d'ajouter le produit : $e");
    }
  }

  // Mettre à jour un produit
  void updateProduct(Product product) async {
    try {
      await _firestore
          .collection('products')
          .doc(product.id)
          .update(product.toMap());
      Get.back();
      Get.snackbar(
        "Succès",
        "Produit mis à jour!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      fetchProducts();
    } catch (e) {
      Get.snackbar("Erreur", "Impossible de mettre à jour le produit : $e");
    }
  }

  // Supprimer un produit
  Future<void> deleteProduct(String productId) async {
    try {
      await _firestore.collection('products').doc(productId).delete();
      Get.snackbar(
        "Succès",
        "Produit supprimé!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      fetchProducts();
    } catch (e) {
      Get.snackbar("Erreur", "Impossible de supprimer le produit : $e");
    }
  }
}

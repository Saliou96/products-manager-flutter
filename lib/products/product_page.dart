import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:products_manager/controllers/product_controller.dart';
import 'package:products_manager/models/product.dart';

class ProductPage extends StatelessWidget {
  final ProductController productController = Get.put(ProductController());

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  ProductPage({super.key});

  void showProductDialog({Product? product}) {
    if (product != null) {
      nameController.text = product.name;
      descriptionController.text = product.description;
      priceController.text = product.price.toString();
    } else {
      nameController.clear();
      descriptionController.clear();
      priceController.clear();
    }

    Get.defaultDialog(
      title: product == null ? 'Ajouter un produit' : 'Modifier le produit',
      content: Column(
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Nom'),
          ),
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(labelText: 'Description'),
          ),
          TextField(
            controller: priceController,
            decoration: const InputDecoration(labelText: 'Prix'),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
      textConfirm: product == null ? 'Ajouter' : 'Modifier',
      textCancel: 'Annuler',
      onConfirm: () {
        if (nameController.text.isNotEmpty &&
            descriptionController.text.isNotEmpty &&
            priceController.text.isNotEmpty) {
          final newProduct = Product(
            id: product?.id ?? '',
            name: nameController.text,
            description: descriptionController.text,
            price: double.parse(priceController.text),
          );

          if (product == null) {
            productController.addProduct(newProduct);
          } else {
            productController.updateProduct(newProduct);
          }
        } else {
          Get.snackbar(
            'Erreur',
            'Veuillez remplir tous les champs',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion des Produits'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Obx(() {
        return ListView.builder(
          itemCount: productController.products.length,
          itemBuilder: (context, index) {
            final product = productController.products[index];
            return Card(
              margin: const EdgeInsets.all(8),
              child: ListTile(
                title: Text(product.name,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle:
                    Text('${product.description}\nPrix: ${product.price}€'),
                isThreeLine: true,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => showProductDialog(product: product),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () =>
                          productController.deleteProduct(product.id),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showProductDialog(product: null),
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }
}
